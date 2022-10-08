//
//  TaskView.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import UIKit

let TaskHistoryCellReuseIdentifier = "TaskHistoryCellReuseIdentifier"

class TaskView: UIViewController {
    
    var viewModel: TaskViewVM? {
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
        label.font.withSize(18)
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
        configureTaskHistoryTableView()
    }
    
    // MARK: - Helpers
    private func configureView() {
        let safeAreaLeftAnchor = view.safeAreaLayoutGuide.leftAnchor
        let safeAreaRightAnchor = view.safeAreaLayoutGuide.rightAnchor
        
        view.addSubview(assignedUserLabel)
        assignedUserLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(assignedTeamLabel)
        assignedTeamLabel.anchor(top: assignedUserLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(taskInformationButton)
        taskInformationButton.anchor(top: assignedTeamLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(taskHistoryTitleLabel)
        taskHistoryTitleLabel.centerX(inView: view, topAnchor: taskInformationButton.bottomAnchor, paddingTop: 24)
        
        view.addSubview(taskHistoryTable)
        taskHistoryTable.anchor(top: taskHistoryTitleLabel.bottomAnchor, left: safeAreaLeftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: safeAreaRightAnchor)
        
    }
    
    private func onViewModelDidSet(viewModel: TaskViewVM) {
        title = viewModel.contentTitle
        assignedUserLabel.text = viewModel.assignedUserString
        assignedTeamLabel.text = viewModel.assignedTeamString
        taskHistoryTitleLabel.attributedText = viewModel.taskHistoryTitleLabelText
        taskInformationButton.setTitle(viewModel.taskInformationButtonString, for: .normal)
        taskHistoryTable.reloadData()
    }
    
    private func configureTaskHistoryTableView() {
        taskHistoryTable.register(TaskViewHistoryCell.self, forCellReuseIdentifier: TaskHistoryCellReuseIdentifier)
//        taskHistoryTable.rowHeight = 60
        taskHistoryTable.delegate = self
        taskHistoryTable.dataSource = self
    }
}

// MARK: - UITableViewDelegate
extension TaskView: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension TaskView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.taskHistoryItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskHistoryCellReuseIdentifier, for: indexPath) as! TaskViewHistoryCell
        if let taskHistoryItem = viewModel?.taskHistoryItems[indexPath.row] {
            cell.viewModel = TaskViewHistoryCellVM(taskHistoryItem: taskHistoryItem)
        }
        
        return cell
    }
}
