//
//  TermsAndPrivacyCell.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 11/3/23.
//

import UIKit

class TermsAndPrivacyCell: UITableViewCell {
    private lazy var termsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("EULA", for: .normal)
        return button
    }()

    private lazy var privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Privacy Policy", for: .normal)
        return button
    }()

    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureInteractables()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView() {
        contentView.addSubview(termsButton)
        contentView.addSubview(privacyButton)
        contentView.backgroundColor = .customBackgroundColor

        termsButton.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.centerXAnchor,
            paddingTop: 2,
            paddingLeft: 8,
            paddingBottom: 2,
            paddingRight: 8)

        privacyButton.anchor(
            top: contentView.topAnchor,
            left: contentView.centerXAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.rightAnchor,
            paddingTop: 2,
            paddingLeft: 8,
            paddingBottom: 2,
            paddingRight: 8)

    }

    func configureInteractables() {
        termsButton.addTarget(self, action: #selector(onTermsButtonPressed), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(onPrivacyButtonPressed), for: .touchUpInside)
    }

    @objc func onTermsButtonPressed() {
        ExternalLinkService.openTermsAndConditionsLink()
    }

    @objc func onPrivacyButtonPressed() {
        ExternalLinkService.openPrivacyPolicyLink()
    }

}
