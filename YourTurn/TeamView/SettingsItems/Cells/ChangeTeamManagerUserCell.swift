//
//  ChangeTeamManagerCell.swift
//  YourTurn
//
//  Created by rjs on 12/22/22.
//

import Foundation

import UIKit

class ChangeTeamManagerUserCell: UITableViewCell {

    var viewModel: ChangeTeamManagerUserCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelSet(viewModel: viewModel)
        }
    }

    // MARK: UI Elements
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    private func configureView() {
        contentView.addSubview(userNameLabel)
        userNameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)

        contentView.addSubview(emailLabel)
        emailLabel.anchor(
            left: contentView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.rightAnchor,
            paddingLeft: 8)
    }

    private func onViewModelSet(viewModel: ChangeTeamManagerUserCellVM) {
        userNameLabel.text = viewModel.teamMemberName
        emailLabel.text = viewModel.teamMemberEmail
    }
}
