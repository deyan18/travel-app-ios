//
//  MainView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

struct MainView: View {
    @State private var isLoggedIn = false
    var body: some View {
        if isLoggedIn {
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
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
