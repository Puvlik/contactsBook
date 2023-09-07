//
//  ContactModel.swift
//  ContactBook
//
//  Created by Паша Клопот on 31.08.23.
//

import Contacts
import Foundation
import UIKit

// MARK: - Constants
private enum Constants {
    static var textSeparator: Character { " " }
    static var emptyString: String { "" }
    static var sideSize: CGFloat { 100 }
    static var defaultFontSize: CGFloat { 30 }
}

// MARK: - ContactModel
/// Model to work with contact
struct ContactModel {
    // Contact full name
    var fullName: String?
    // All numbers of contact
    var phoneNumbers: [ContactPhoneNumber]
    // Contact image
    var image: UIImage?
    // Contact's initials
    var initials: String? {
        guard let words = fullName?.split(separator: Constants.textSeparator),
                !words.isEmpty,
                let firstWordLetter = words.first?.first else { return nil }

        guard words.count > 1, let lastWordLetter = words.last?.first else { return String(firstWordLetter) }

        return "\(String(firstWordLetter)) \(String(lastWordLetter))"
    }
    // Is contact empty
    var isEmpty: Bool {
        fullName == nil && phoneNumbers.isEmpty && image == nil
    }

    // MARK: - Init
    init(contact: CNContact) {
        fullName = CNContactFormatter.string(from: contact, style: .fullName)

        if contact.phoneNumbers.isEmpty {
            phoneNumbers = [.init(numberType: "Unknown type", number: "Unable to get contact number")]
        } else {
            phoneNumbers = contact.phoneNumbers.compactMap { phone in
                let localizedLabel = CNLabeledValue<NSString>.localizedString(
                    forLabel: phone.label ?? Constants.emptyString)
                return .init(numberType: localizedLabel, number: phone.value.stringValue)
            }
        }

        guard let contactImageData = contact.imageData else {
            let defaultSize = CGSize(width: Constants.sideSize, height: Constants.sideSize)
            image = initials?.generateImageFromInitials(
                font: .boldSystemFont(ofSize: Constants.defaultFontSize),
                frame: .init(origin: .zero, size: defaultSize)
            )
            return
        }
        image = UIImage(data: contactImageData)
    }
}

// MARK: - ContactPhoneNumber
/// Model to work with contact numbers
struct ContactPhoneNumber {
    // Number type
    var numberType: String
    // Number value
    var number: String
}
