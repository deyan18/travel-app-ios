//
//  LoadingView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import SwiftUI

struct LoadingView: View {

    @EnvironmentObject var vm: MainViewModel
    var body: some View {
        ZStack{
            if vm.isLoading{
                Rectangle()
                    .fill(.black.opacity(0.3))
                    .ignoresSafeArea()

                ProgressView()
                    .padding(15)
                    .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: vm.isLoading)
    }
}

