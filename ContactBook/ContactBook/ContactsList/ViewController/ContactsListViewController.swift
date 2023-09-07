//
//  ContactsListViewController.swift
//  ContactBook
//
//  Created by Паша Клопот on 31.08.23.
//

import UIKit

// MARK: - Constants
private enum Constants {
    static var contactCellIdentifier: String { "ContactListTableViewCell" }
    static var navigationItemText: String { "Contacts" }
    static var settingsButtonTitleText: String { "Go to Settings" }
    static var permissionError: String { "Failed to access contacts" }
    static var noInfoErrorText: String { "No information to show" }
    static var permissionErrorPlaceholderText: String { """
    Failed to access contacts.
    Please go to Settings and give access for app to use your Contacts
    """ }

    static var navControllerColor: UIColor { .navControllerColor }
    static var defaultTextColor: UIColor { .labelTextColor }
    static var placeholderTextLabelFont: UIFont { .boldSystemFont(ofSize: 25) }
    static var navControllerTitleFont: UIFont { .boldSystemFont(ofSize: 19) }

    static var defaultPadding16: CGFloat { 16 }
    static var settingsButtonAlpha: CGFloat { 0.2 }
    static var settingsButtonCornerRadius: CGFloat { 16 }
    static var settingsButtonHeightValue: CGFloat { 45 }
}

// MARK: - ContactsListViewController
final class ContactsListViewController: UIViewController {

    // MARK: - Private properties
    private lazy var contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var placeholderTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.numberOfLines = 0
        label.textColor = Constants.defaultTextColor
        label.font = Constants.placeholderTextLabelFont
        label.textAlignment = .center
        return label
    }()

    private lazy var openSettingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.backgroundColor = .gray.withAlphaComponent(Constants.settingsButtonAlpha)
        button.setTitleColor(Constants.defaultTextColor, for: .normal)
        button.layer.cornerRadius = Constants.settingsButtonCornerRadius
        button.setTitle(Constants.settingsButtonTitleText, for: .normal)
        button.addTarget(self, action: #selector(openDeviceSettings), for: .touchUpInside)
        return button
    }()

    private lazy var dataSource = ContactsListTableViewDataSource(with: contactsTableView)

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        setupTableView()
        setupSubviews()
        getUserContacts()
    }

    // MARK: - Private methods
    private func setupNavController() {
        view.backgroundColor = Constants.navControllerColor
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.defaultTextColor,
            .font: Constants.navControllerTitleFont
        ]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = Constants.navigationItemText
    }

    private func setupTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = dataSource
        contactsTableView.register(ContactListTableViewCell.self,
                                   forCellReuseIdentifier: Constants.contactCellIdentifier)
        view.addSubview(contactsTableView)

        contactsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBarHeight).isActive = true
        contactsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contactsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupSubviews() {
        view.addSubview(placeholderTextLabel)
        view.addSubview(openSettingsButton)

        placeholderTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        placeholderTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: Constants.defaultPadding16).isActive = true
        placeholderTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -Constants.defaultPadding16).isActive = true

        openSettingsButton.topAnchor.constraint(equalTo: placeholderTextLabel.bottomAnchor,
                                                constant: Constants.defaultPadding16).isActive = true
        openSettingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: Constants.defaultPadding16).isActive = true
        openSettingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -Constants.defaultPadding16).isActive = true
        openSettingsButton.heightAnchor.constraint(equalToConstant: Constants.settingsButtonHeightValue).isActive = true
    }

    @objc private func openDeviceSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
        }
    }

    private func getUserContacts() {
        ContactsManager.getContactsPermission { [weak self] accessGranted in
            guard let self = self else { return }

            self.placeholderTextLabel.isHidden = accessGranted
            self.openSettingsButton.isHidden = accessGranted

            if !accessGranted {
                ContactsManager.showAlert(with: Constants.permissionError) { [weak self] alert in
                    guard let self = self else { return }
                    self.present(alert, animated: true, completion: nil)
                }
                self.placeholderTextLabel.text = Constants.permissionErrorPlaceholderText
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let result = ContactsManager.fetchContactsFromContactsBook()
                if let error = result.error {
                    ContactsManager.showAlert(with: error.localizedDescription) { [weak self] alert in
                        guard let self = self else { return }
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }

                self.dataSource.groupContactsForSections(result.contacts)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ContactsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let contact = dataSource.getContactByIndex(indexPath: indexPath),
            !contact.isEmpty
        else {
            ContactsManager.showAlert(with: Constants.noInfoErrorText) { [weak self] alert in
                guard let self = self else { return }
                self.present(alert, animated: true, completion: nil)
            }
            return
        }

        let contactDetailsVC = ContactInfoViewController(contact: contact)
        present(contactDetailsVC, animated: true)
    }
}
