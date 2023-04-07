//
//  ProfileView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: MainViewModel
    @State private var triggerNavigation = false
    var body: some View {
        NavigationStack{
            VStack {
                profileImageView(url: vm.currentUser?.pfpURL ?? "", size:100)
                Text(vm.currentUser?.name ?? "")
                    .font(.title2)
                NavigationLink {
                    SettingsView()
                } label: {

                }




                Spacer()

            }

            .toolbar {
                NavigationLink(
                    destination: SettingsView(),
                    label:{
                        Image(systemName: "gear")
                    })
            }
        }

    }
}


