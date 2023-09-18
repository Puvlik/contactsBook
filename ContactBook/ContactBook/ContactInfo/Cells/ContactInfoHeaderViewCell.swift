//
//  ContactInfoHeaderViewCell.swift
//  ContactBook
//
//  Created by Паша Клопот on 5.09.23.
//

import Foundation
import UIKit

// MARK: - Constants
private enum Constants {
    static var contactImageViewCornerRadius: CGFloat { 50 }
    static var contactNameLabelHeight: CGFloat { 30 }
    static var defaultPadding16: CGFloat { 16 }
    static var stackViewSpacing: CGFloat { 5 }
    static var contactImageFrameValue: CGFloat { 200 }

    static var contactInfoTextColor: UIColor { .labelTextColor }

    static var contactNameTextFont: UIFont { .boldSystemFont(ofSize: 22) }
}

// MARK: - ContactInfoHeaderViewCell
final class ContactInfoHeaderViewCell: UITableViewCell {

    // MARK: - Public properties
    var data: (image: UIImage?, name: String?) {
        didSet {
            contactImageView.image = data.image
            contactNameLabel.text = data.name
        }
    }

    // MARK: - Private Properties
    private lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = Constants.contactImageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var contactNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Constants.contactInfoTextColor
        label.font = Constants.contactNameTextFont
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

    // MARK: - Private Methods
    private func setupSubviews() {
        addSubview(contactImageView)
        addSubview(contactNameLabel)

        contactImageView.topAnchor.constraint(equalTo: topAnchor,
                                              constant: Constants.defaultPadding16).isActive = true
        contactImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contactImageView.heightAnchor.constraint(equalToConstant: Constants.contactImageFrameValue).isActive = true
        contactImageView.widthAnchor.constraint(equalToConstant: Constants.contactImageFrameValue).isActive = true

        contactNameLabel.topAnchor.constraint(equalTo: contactImageView.bottomAnchor,
                                              constant: Constants.defaultPadding16).isActive = true
        contactNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contactNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contactNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                 constant: -Constants.defaultPadding16).isActive = true
    }
}
