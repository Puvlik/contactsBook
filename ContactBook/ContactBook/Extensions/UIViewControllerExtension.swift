//
//  UIViewControllerExtension.swift
//  ContactBook
//
//  Created by Паша Клопот on 5.09.23.
//

import Foundation
import UIKit

// MARK: - UIViewController
extension UIViewController {
    /// Calculate navController height
    var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
}
