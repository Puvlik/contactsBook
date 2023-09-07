//
//  PhoneNumberDetailsCell.swift
//  ContactBook
//
//  Created by Паша Клопот on 5.09.23.
//

import Foundation
import UIKit

// MARK: - Constants
private enum Constants {
    static var stackViewSpacing: CGFloat { 5 }
    static var defaultSidePadding16: CGFloat { 16 }
    static var defaultSidePadding24: CGFloat { 24 }
    static var contactImageSizeValue: CGFloat { 60 }

    static var contactInfoTextColor: UIColor { .labelTextColor }

    static var contactNameTextFont: UIFont { .boldSystemFont(ofSize: 16) }
    static var contactPhoneNumberFont: UIFont { .systemFont(ofSize: 18, weight: .medium) }
}

final class PhoneNumberDetailsCell: UITableViewCell {

    // MARK: - Public properties
    var data: ContactPhoneNumber? {
        didSet {
            guard let data = data else { return }
            phoneTypeLabel.text = data.numberType
            phoneNumberLabel.text = data.number
        }
    }

    // MARK: - Private properties
    private lazy var phoneInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = Constants.stackViewSpacing
        return stack
    }()

    private lazy var phoneTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = Constants.contactInfoTextColor
        label.font = Constants.contactNameTextFont
        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
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
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupSubviews() {
        phoneInfoStackView.addArrangedSubview(phoneTypeLabel)
        phoneInfoStackView.addArrangedSubview(phoneNumberLabel)
        addSubview(phoneInfoStackView)

        phoneInfoStackView.topAnchor.constraint(equalTo: topAnchor,
                                                  constant: Constants.defaultSidePadding16).isActive = true
        phoneInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: Constants.defaultSidePadding16).isActive = true
        phoneInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -Constants.defaultSidePadding16).isActive = true
        phoneInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                     constant: -Constants.defaultSidePadding24).isActive = true
    }
}
