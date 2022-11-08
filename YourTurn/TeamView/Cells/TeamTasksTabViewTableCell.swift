//
//  TeamTasksTabViewTableCell.swift
//  YourTurn
//
//  Created by rjs on 11/7/22.
//

import UIKit

class TeamTasksTabViewTableCell: UITableViewCell {
    
    var viewModel: TeamTasksTabViewCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelSet(viewModel: viewModel)
        }
    }
    
    // MARK: UI Elements
    private lazy var taskNameLabel: UILabel = {
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
        contentView.addSubview(taskNameLabel)
        taskNameLabel.fillSuperview()
    }
    
    private func onViewModelSet(viewModel: TeamTasksTabViewCellVM) {
        taskNameLabel.text = viewModel.taskLabel
    }
}
