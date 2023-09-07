//
//  ContactListTableViewCell.swift
//  ContactBook
//
//  Created by Паша Клопот on 5.09.23.
//

import Foundation
import UIKit

// MARK: - Constants
private enum Constants {
    static var stackViewSpacing: CGFloat { 5 }
    static var contactImageViewCornerRadius: CGFloat { 24 }
    static var defaultSidePadding16: CGFloat { 16 }
    static var defaultSidePadding24: CGFloat { 24 }
    static var contactImageSizeValue: CGFloat { 60 }

    static var contactInfoTextColor: UIColor { .labelTextColor }

    static var contactNameTextFont: UIFont { .boldSystemFont(ofSize: 18) }
    static var contactPhoneNumberFont: UIFont { .systemFont(ofSize: 16) }
}

// MARK: - ContactListTableViewCell
final class ContactListTableViewCell: UITableViewCell {

    // MARK: - Public properties
    var data: ContactModel? {
        didSet {
            guard let data = data else { return }
            contactImageView.image = data.image
            contactNameLabel.text = data.fullName
            contactPhoneNumberLabel.text = data.phoneNumbers.first?.number
        }
    }

    // MARK: - Private properties
    private lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.contactImageViewCornerRadius
        return imageView
    }()

    private lazy var contactInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = Constants.stackViewSpacing
        return stack
    }()

    private lazy var contactNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = Constants.contactInfoTextColor
        label.font = Constants.contactNameTextFont
        return label
    }()

    private lazy var contactPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = Constants.contactInfoTextColor
        label.font = Constants.contactPhoneNumberFont
        return label
    }()

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupSubviews() {
        addSubview(contactImageView)
        contactInfoStackView.addArrangedSubview(contactNameLabel)
        contactInfoStackView.addArrangedSubview(contactPhoneNumberLabel)
        addSubview(contactInfoStackView)

        contactImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contactImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: Constants.defaultSidePadding16).isActive = true
        contactImageView.widthAnchor.constraint(equalToConstant: Constants.contactImageSizeValue).isActive = true
        contactImageView.heightAnchor.constraint(equalToConstant: Constants.contactImageSizeValue).isActive = true

        contactInfoStackView.topAnchor.constraint(equalTo: topAnchor,
                                                  constant: Constants.defaultSidePadding24).isActive = true
        contactInfoStackView.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor,
                                                      constant: Constants.defaultSidePadding16).isActive = true
        contactInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -Constants.defaultSidePadding16).isActive = true
        contactInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                     constant: -Constants.defaultSidePadding24).isActive = true
    }
}
