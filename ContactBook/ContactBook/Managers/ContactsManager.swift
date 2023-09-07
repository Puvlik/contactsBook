//
//  ContactsManager.swift
//  ContactBook
//
//  Created by Паша Клопот on 31.08.23.
//

import Contacts
import Foundation
import UIKit

// MARK: - ContactsManager
/// Manager to check for permission and fetch contacts
final class ContactsManager {
    class func getContactsPermission(_ completion: @escaping (_ access: Bool) -> Void) {
        let contactsAuthorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)

        switch contactsAuthorizationStatus {
        case .authorized:
            completion(true)
        case .denied, .notDetermined:
            CNContactStore().requestAccess(for: CNEntityType.contacts) { access, _ in
                DispatchQueue.main.async {
                    completion(access)
                }
            }
        default:
            completion(false)
        }
    }

    class func fetchContactsFromContactsBook() -> (contacts: [ContactModel], error: Error?) {
        let contactStore = CNContactStore()
        let contactKeys = [
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
        ]
        let contactsFetchRequest = CNContactFetchRequest(keysToFetch: contactKeys)
        var contacts = [ContactModel]()
        var fetchError: Error?

        do {
            try contactStore.enumerateContacts(with: contactsFetchRequest) { contact, _ in
                contacts.append(ContactModel(contact: contact))
            }
        } catch let error {
            fetchError = error
        }

        return (contacts, fetchError)
    }

    class func showAlert(with message: String, completion: (UIAlertController) -> ()) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        completion(alert)
    }
}
