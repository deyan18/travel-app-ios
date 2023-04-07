//
//  UIViewExtension.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 7/4/23.
//

import Foundation
import UIKit
import SwiftUI

extension UIApplication{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    // retrieve RootView
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return . init()

        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}

struct HideTabBarOnPush<Content: View>: UIViewControllerRepresentable {
    var content: () -> Content

    func makeUIViewController(context: UIViewControllerRepresentableContext<HideTabBarOnPush>) -> UIViewController {
        let childView = UIHostingController(rootView: content())
        let viewController = UINavigationController(rootViewController: childView)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<HideTabBarOnPush>) {}

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.hidesBottomBarWhenPushed != navigationController.topViewController?.hidesBottomBarWhenPushed {
            navigationController.setNavigationBarHidden(viewController.hidesBottomBarWhenPushed, animated: animated)
        }
    }
}
