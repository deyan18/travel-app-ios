//
//  ProfileView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: MainViewModel

    @State private var showingLogoutAlert = false
    @State private var showingDeleteAlert = false

    var body: some View {
        VStack {
            profileImageView(url: vm.currentUser?.pfpURL ?? "")
            Text(vm.currentUser?.name ?? "")
            customButton(title: "Sign Out", backgroundColor: .orange, foregroundColor: .white) {
                showingLogoutAlert = true
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Log out?"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Log out")) {
                        vm.signOut()
                    },
                    secondaryButton: .cancel()
                )
            }

            customButton(title: "Delete Account", backgroundColor: .red, foregroundColor: .white) {
                showingDeleteAlert = true
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete account?"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        vm.deleteUserAccount()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}


