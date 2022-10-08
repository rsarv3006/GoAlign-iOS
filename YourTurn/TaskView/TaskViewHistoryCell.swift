//
//  TaskViewHistoryCell.swift
//  YourTurn
//
//  Created by Robby on 10/6/22.
//

import UIKit

class TaskViewHistoryCell: UITableViewCell {
    
    // MARK: - Properties
    var viewModel: TaskViewHistoryCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelSet(viewModel: viewModel)
        }
    }
    
    // MARK: - UI Elements
    private lazy var completedByLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var completedDateLabel: UILabel = {
        let label = UILabel()
        
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
    
    func configureView() {
        addSubview(completedByLabel)
        completedByLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8)
        
        addSubview(completedDateLabel)
        completedDateLabel.anchor(top: completedByLabel.bottomAnchor, left: leftAnchor)
    }
    
    func onViewModelSet(viewModel: TaskViewHistoryCellVM) {
        completedByLabel.text = viewModel.completedByLabelString
        completedDateLabel.text = viewModel.dateCompletedLabelString
    }
}
