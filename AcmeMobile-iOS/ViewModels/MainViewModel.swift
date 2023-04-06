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

    /*func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        FirebaseManager.shared.firestore.collection("Users")
            .document(uid).getDocument { snapshot, err in
                if let err = err {
                    print("Error: ", err)
                    //self.signOut()
                    return
                }

                guard let data = snapshot?.data() else { return }
                self.currentUser = .init(data: data)

                self.fetchUserDependantData()
            }
    }*/
}
