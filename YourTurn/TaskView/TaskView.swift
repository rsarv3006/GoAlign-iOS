//
//  TaskView.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import UIKit

class TaskView: UIViewController {
    
    var viewModel: TaskVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelDidSet(viewModel: viewModel)
        }
    }
    
    // MARK: UI Elements
    private lazy var assignedUserLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var assignedTeamLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var taskHistoryTitleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var taskHistoryTable: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var taskInformationButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Helpers
    func configureView() {
        let safeAreaLeftAnchor = view.safeAreaLayoutGuide.leftAnchor
        let safeAreaRightAnchor = view.safeAreaLayoutGuide.rightAnchor
        
        view.addSubview(assignedUserLabel)
        assignedUserLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(assignedTeamLabel)
        assignedTeamLabel.anchor(top: assignedUserLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(taskInformationButton)
        taskInformationButton.anchor(top: assignedTeamLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
    }
    
    func onViewModelDidSet(viewModel: TaskVM) {
        title = viewModel.contentTitle
        assignedUserLabel.text = viewModel.assignedUserString
        assignedTeamLabel.text = viewModel.assignedTeamString
        taskHistoryTitleLabel.text = viewModel.taskHistoryTitleLabelString
        taskInformationButton.setTitle(viewModel.taskInformationButtonString, for: .normal)
        taskHistoryTable.reloadData()
    }
}
