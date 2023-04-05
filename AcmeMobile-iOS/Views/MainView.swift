//
//  MainView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 5/4/23.
//

import SwiftUI

struct MainView: View {
    @State private var isLoggedIn = true
    var body: some View {
        if isLoggedIn {
            HomeView()
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
