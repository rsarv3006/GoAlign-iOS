//
//  TeamInviteSubCellView.swift
//  YourTurn
//
//  Created by rjs on 8/31/22.
//

import Foundation
import UIKit

class TeamInviteSubCellView: UITableViewCell {

    var viewModel: TeamInviteSubCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            declineInviteButton.setTitle(viewModel.declineButtonLabel, for: .normal)
            acceptInviteButton.setTitle(viewModel.acceptButtonLabel, for: .normal)
        }
    }

    var delegate: TeamInvitesViewControllerDelegate?

    // MARK: - UI Elements
    private lazy var declineInviteButton: StandardButton = {
        let button = StandardButton()
        button.setTitle("Decline", for: .normal)
        button.addTarget(self, action: #selector(onDeclinePress), for: .touchUpInside)
        return button
    }()

    private lazy var acceptInviteButton: StandardButton = {
        let button = StandardButton()
        button.setTitle("Accept", for: .normal)
        button.addTarget(self, action: #selector(onAcceptPress), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [declineInviteButton, acceptInviteButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView() {
        contentView.backgroundColor = .customBackgroundColor
        contentView.addSubview(buttonsStack)
        buttonsStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 16, paddingRight: 16)
        acceptInviteButton.setWidth(120)
        declineInviteButton.setWidth(120)
    }

    @objc func onAcceptPress() {
        viewModel?.acceptInvite(delegate: delegate)
    }

    @objc func onDeclinePress() {
        viewModel?.declineInvite(delegate: delegate)
    }
}
