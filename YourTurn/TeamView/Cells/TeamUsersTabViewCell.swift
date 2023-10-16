//
//  TeamUsersTabViewCell.swift
//  YourTurn
//
//  Created by rjs on 11/8/22.
//

import UIKit

class TeamUsersTabViewCell: UITableViewCell {

    var viewModel: TeamUsersTabViewCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelSet(viewModel: viewModel)
        }
    }

    // MARK: UI Elements
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        label.font = .systemFont(ofSize: 18)
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
        contentView.backgroundColor = .customBackgroundColor
        contentView.addSubview(userNameLabel)
        userNameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 12)
        userNameLabel.centerY(inView: contentView)

    }

    private func onViewModelSet(viewModel: TeamUsersTabViewCellVM) {
        userNameLabel.text = viewModel.username
    }
}
