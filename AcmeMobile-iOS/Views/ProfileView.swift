//
//  ProfileView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: MainViewModel

    var body: some View {
        VStack{
            profileImageView(url: vm.currentUser?.pfpURL ?? "")
            Text(vm.currentUser?.name ?? "")
            customButton(title: "Sign Out", backgroundColor: .orange, foregroundColor: .white) {
                vm.signOut()
            }
        }
    }
}


