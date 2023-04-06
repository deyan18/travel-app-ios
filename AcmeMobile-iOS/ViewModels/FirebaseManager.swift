//
//  FirebaseManager.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import Firebase
import FirebaseStorage
import FirebaseFirestore
import Foundation

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore

    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()

        auth = Auth.auth()
        storage = Storage.storage()
        firestore = Firestore.firestore()

        super.init()
    }
}
