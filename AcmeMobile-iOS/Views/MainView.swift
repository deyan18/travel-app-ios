//
//  MainView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var vm: MainViewModel
    var body: some View {
        ZStack{


            if vm.signedIn {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Explore", systemImage: "airplane")
                        }
                    BookmarksView()
                        .tabItem {
                            Label("Bookmarks", systemImage: "bookmark")
                        }
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }.background(.ultraThickMaterial)
            }else{
                LoginView()
            }

            LoadingView()

        }.alert(vm.alertMessage, isPresented: $vm.showAlert, actions: {})
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
