//
//  StringExtension.swift
//  ContactBook
//
//  Created by Паша Клопот on 31.08.23.
//

import Foundation
import UIKit

// MARK: - String
extension String {
    func generateImageFromInitials(
        font: UIFont,
        textColor: UIColor = .white,
        backgroundColor: UIColor = .generateRandomColor,
        frame: CGRect) -> UIImage? {
            let textLabel = UILabel(frame: frame)
            textLabel.textAlignment = .center
            textLabel.backgroundColor = backgroundColor
            textLabel.textColor = textColor
            textLabel.font = font
            textLabel.text = self
            UIGraphicsBeginImageContextWithOptions(frame.size, false, .zero)

            guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
            textLabel.layer.render(in: currentContext)

            return UIGraphicsGetImageFromCurrentImageContext()
        }
}
