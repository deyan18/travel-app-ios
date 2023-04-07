//
//  UIViewExtension.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 7/4/23.
//

import Foundation
import UIKit

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
