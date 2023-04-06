//
//  AcmeMobile_iOSApp.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI
import Firebase

@main
struct AcmeMobile_iOSApp: App {
    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
