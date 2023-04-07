//
//  MainViewModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import FirebaseFirestore

class MainViewModel: ObservableObject {
    @Published var signedIn = false
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    @Published var alertMessage = ""

    func fetchCurrentUser() async {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        do{
            let user = try await FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument(as: User.self)

            await MainActor.run(body: {
                self.currentUser = user
            })
        }catch{
            
        }
    }

    func alertUser(_ message: String){
        alertMessage = message
        self.isLoading = false
        showAlert.toggle()
    }

    func setError(_ error: Error) {
        alertUser(error.localizedDescription)
    }

    func signOut() {
        self.signedIn = false
        try? FirebaseManager.shared.auth.signOut()
    }

    func googleLogin(){

        self.isLoading = true

        guard let clientID = FirebaseApp.app()?.options.clientID else { return }



        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config



        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.getRootViewController()) { user, error in
            if let error = error {
                self.setError(error)
                return
            }

            guard let idToken = user?.user.idToken else {
                self.isLoading = false
                return
            }

            guard let accessToken = user?.user.accessToken else {
                self.isLoading = false
                return
            }



            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

            let config = GIDConfiguration(clientID: clientID)

            GIDSignIn.sharedInstance.configuration = config

            // Firebase Authentication
            Auth.auth().signIn(with: credential) {result, err in
                self.isLoading = false
                if let err = err {
                    print(err.localizedDescription)
                    return
                }

                guard let userData = result?.user else {
                    return
                }

                FirebaseManager.shared.firestore.collection("Users").document(userData.uid).getDocument { snapshot, error in
                    if !snapshot!.exists{
                        let user = User(UID: userData.uid, email: userData.email ?? "", name: userData.displayName ?? "", pfpURL: userData.photoURL?.absoluteString ?? "")
                        self.saveUserData(user)
                        Task{
                            await self.fetchCurrentUser()
                        }
                    }
                }

                self.signedIn = true

                Task{
                    await self.fetchCurrentUser()
                }

            }

        }


    }

    func saveUserData(_ user: User){

        do{
            try FirebaseManager.shared.firestore.collection("Users").document(user.UID).setData(from: user, merge: true)
        }catch{
            self.setError(error)
        }
    }
    

    func deleteUserAccount() {
        self.isLoading = true
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }


        FirebaseManager.shared.auth.currentUser?.delete(completion: { err in
            if let err = err {
                self.isLoading = false
                self.setError(err)
                return
            }
            let refImg = FirebaseManager.shared.storage.reference(withPath: "ProfilePictures/\(uid)")

            refImg.delete { err in
                if let err = err {
                    print("Error: \(err)")
                }
            }

            FirebaseManager.shared.firestore.collection("Users")
                .document(uid).delete { err in
                    if let err = err {
                        print("Error: \(err)")
                    }
                    self.signedIn = false
                }


            self.isLoading = false
        })
    }

    func isGoogleUser() -> Bool{
        let providerId = Auth.auth().currentUser?.providerData.first?.providerID

        return providerId == "google.com"
    }

   
}
