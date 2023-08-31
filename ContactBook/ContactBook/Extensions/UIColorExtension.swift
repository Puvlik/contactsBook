//
//  UIColorExtension.swift
//  ContactBook
//
//  Created by Паша Клопот on 31.08.23.
//

import Foundation
import UIKit

extension UIColor {
    static var generateRandomColor: UIColor {
        UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
