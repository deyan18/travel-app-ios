//
//  AcmeMobile_iOSApp.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import Firebase
import GoogleSignIn
import SwiftUI

@main
struct AcmeMobile_iOSApp: App {
    @StateObject var vm: MainViewModel = MainViewModel()
    @StateObject var lm: LocationManager = LocationManager()

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(vm)
                .environmentObject(lm)
                .onAppear {
                    if FirebaseManager.shared.auth.currentUser != nil {
                        vm.requestNotif()
                        vm.connectMQTT()
                        vm.fetchCurrentUser()
                        vm.fetchTrips()
                        vm.signedIn = true
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    /*@available(iOS 9.0, *)
     func application(_ application: UIApplication, open url: URL,
                      options: [UIApplication.OpenURLOptionsKey: Any])
     -> Bool {
         return GIDSignIn.sharedInstance.handle(url)
     }*/

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification response here
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle notification presentation here
        completionHandler([.badge, .sound, .banner]) // Choose desired presentation options
    }
}
