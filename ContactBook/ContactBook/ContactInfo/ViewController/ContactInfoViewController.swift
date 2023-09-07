//
//  ContactInfoViewController.swift
//  ContactBook
//
//  Created by Паша Клопот on 5.09.23.
//

import Foundation
import UIKit

// MARK: - Constants
private enum Constants {
    static var phoneCellIdentifier: String { "PhoneNumberDetailsCell" }
    static var contactHeaderCellIdentifier: String { "ContactInfoHeaderViewCell" }
}

// MARK: - ContactInfoViewController
final class ContactInfoViewController: UIViewController {

    // MARK: - Private properties
    private var contact: ContactModel?

    private lazy var contactPhonesTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhoneNumberDetailsCell.self,
                                   forCellReuseIdentifier: Constants.phoneCellIdentifier)
        tableView.register(ContactInfoHeaderViewCell.self,
                                   forCellReuseIdentifier: Constants.contactHeaderCellIdentifier)
        return tableView
    }()

    // MARK: - Init
    init(contact: ContactModel) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Private Methods
    private func setupTableView() {
        contactPhonesTableView.delegate = self
        contactPhonesTableView.dataSource = self
        view.addSubview(contactPhonesTableView)

        contactPhonesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contactPhonesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contactPhonesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contactPhonesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDelegate
extension ContactInfoViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension ContactInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (contact?.phoneNumbers.count ?? .zero) + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = contactPhonesTableView.dequeueReusableCell(
                withIdentifier: Constants.contactHeaderCellIdentifier,
                for: indexPath) as? ContactInfoHeaderViewCell else { return UITableViewCell() }
            cell.data = (contact?.image, contact?.fullName)
            return cell
        default:
            guard let cell = contactPhonesTableView.dequeueReusableCell(
                withIdentifier: Constants.phoneCellIdentifier,
                for: indexPath) as? PhoneNumberDetailsCell else { return UITableViewCell() }
            cell.data = contact?.phoneNumbers[indexPath.row - 1]
            return cell
        }
    }
}
