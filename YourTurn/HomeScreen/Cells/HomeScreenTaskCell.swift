//
//  TaskCellHomeScreen.swift
//  YourTurn
//
//  Created by rjs on 6/22/22.
//

import Foundation
import UIKit

class HomeScreenTaskCell: UITableViewCell {
    // MARK: - Properties
    var viewModel: HomeScreenTaskCellVM? {
        didSet {
            onViewModelSet()
        }
    }

    private let taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .customText
        return label
    }()

    private let timeUntilStartOrEndLabel: UILabel = {
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

    // MARK: - Helpers
    private func configureView() {
        backgroundColor = .customBackgroundColor
        addSubview(taskNameLabel)
        taskNameLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 30)

        addSubview(timeUntilStartOrEndLabel)
        timeUntilStartOrEndLabel.anchor(
            top: taskNameLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: 20)
    }

    private func onViewModelSet() {
        guard let viewModel = viewModel else { return }
        taskNameLabel.text = viewModel.taskNameLabelString
        timeUntilStartOrEndLabel.text = viewModel.timeIntervalLabelString
    }
}
