//
//  HomeScreenTeamCell.swift
//  YourTurn
//
//  Created by rjs on 6/26/22.
//

import Foundation
import UIKit

class HomeScreenTeamCell: UITableViewCell {
    // MARK: - Properties
    var viewModel: HomeScreenTeamCellVM? {
        didSet {
            onViewModelSet()
        }
    }

    private let teamNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .customText
        return label
    }()

    private let numberOfTeamTasksLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    private func configureView() {
        backgroundColor = .customBackgroundColor
        addSubview(teamNameLabel)
        teamNameLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 30)

        addSubview(numberOfTeamTasksLabel)
        numberOfTeamTasksLabel.anchor(top: teamNameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor)
    }

    private func onViewModelSet() {
        guard let viewModel = viewModel else { return }

        teamNameLabel.text = viewModel.teamNameLabelString
        numberOfTeamTasksLabel.text = viewModel.numberOfTeamTasksLabelString
    }
}
