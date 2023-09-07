//
//  ContactsListTableViewDataSource.swift
//  ContactBook
//
//  Created by Паша Клопот on 5.09.23.
//

import Foundation
import UIKit

// MARK: - Constants
private enum Constants {
    static var contactCellIdentifier: String { "ContactListTableViewCell" }
}

// MARK: - ContactsListTableViewDataSource
final class ContactsListTableViewDataSource: NSObject {

    // MARK: - Private typealias
    private typealias ContactsSection = (letter: String, contacts: [ContactModel])

    // MARK: - Private Properties
    private let contactsTableView: UITableView
    private var contactsTableViewSections = [ContactsSection]() {
        didSet {
            contactsTableView.reloadData()
        }
    }

    // MARK: - Init
    init(with tableView: UITableView) {
        self.contactsTableView = tableView
    }

    // MARK: - Public Methods
    func groupContactsForSections(_ contacts: [ContactModel]) {
        let contactSections = Dictionary(grouping: contacts) { $0.fullName?.first ?? Character("*") }
            .map { (letter: String($0), contacts: $1) }
            .sorted { $0.letter < $1.letter }
        contactsTableViewSections = contactSections
    }

    func getContactByIndex(indexPath: IndexPath) -> ContactModel? {
        guard
            indexPath.section < contactsTableViewSections.count,
            indexPath.row < contactsTableViewSections[indexPath.section].contacts.count
        else { return nil }
        return contactsTableViewSections[indexPath.section].contacts[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension ContactsListTableViewDataSource: UITableViewDataSource {
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        contactsTableViewSections.compactMap { $0.letter }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        contactsTableViewSections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        contactsTableViewSections[section].letter
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactsTableViewSections[section].contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contactsTableViewSections[indexPath.section].contacts[indexPath.row]
        guard let cell = contactsTableView.dequeueReusableCell(
            withIdentifier: Constants.contactCellIdentifier,
            for: indexPath) as? ContactListTableViewCell else { return UITableViewCell() }
        cell.data = contact
        return cell
    }
}
