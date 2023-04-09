//
//  AcmeMobile_iOSApp.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI
import Firebase
import GoogleSignIn


@main
struct AcmeMobile_iOSApp: App {
    @StateObject var vm: MainViewModel = MainViewModel()
    @StateObject var lm: LocationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(vm)
                .environmentObject(lm)
                .onAppear{
                    
                    if FirebaseManager.shared.auth.currentUser != nil{

                        vm.fetchCurrentUser()
                        //vm.addRandomTripsToFirestore()
                        vm.fetchTrips()
                        vm.signedIn = true
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

}
