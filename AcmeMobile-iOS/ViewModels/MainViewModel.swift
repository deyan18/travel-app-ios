//
//  MainViewModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import Foundation

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

}
