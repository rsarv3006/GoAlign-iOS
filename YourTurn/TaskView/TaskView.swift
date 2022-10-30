//
//  TaskView.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import UIKit
import Combine

let TaskEntryCellReuseIdentifier = "TaskEntryCellReuseIdentifier"

class TaskView: UIViewController {
    var subscriptions = Set<AnyCancellable>()
    
    private(set) var requestHomeReload = PassthroughSubject<Bool, Never>()
    
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
    
    private lazy var subViewMarkTaskCompleteButton: UIView = {
        let subView = UIView()
        return subView
    }()
    
    private lazy var markTaskCompleteButton: StandardButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = StandardButton(configuration: configuration)
        button.addTarget(self, action: #selector(onTouchUpInsideMarkTaskCompleteButton), for: .touchUpInside)
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
        
        view.backgroundColor = .systemBackground
        
        taskInformationButton.addTarget(self, action: #selector(onTouchUpInsideTaskInformatioButton), for: .touchUpInside)
        
        view.addSubview(subViewMarkTaskCompleteButton)
        subViewMarkTaskCompleteButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor, height: 44)
        
        view.addSubview(assignedUserLabel)
        assignedUserLabel.anchor(top: subViewMarkTaskCompleteButton.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(assignedTeamLabel)
        assignedTeamLabel.anchor(top: assignedUserLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(taskInformationButton)
        taskInformationButton.anchor(top: assignedTeamLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(taskHistoryTitleLabel)
        taskHistoryTitleLabel.centerX(inView: view, topAnchor: taskInformationButton.bottomAnchor, paddingTop: 24)
        
        view.addSubview(taskHistoryTable)
        taskHistoryTable.anchor(top: taskHistoryTitleLabel.bottomAnchor, left: safeAreaLeftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: safeAreaRightAnchor, paddingLeft: 8, paddingRight: 8)
        
        configureMarkTaskCompleteButton()
    }
    
    private func configureMarkTaskCompleteButton() {
        guard let viewModel = viewModel else { return }
        
        viewModel.checkIfMarkTaskCompleteButtonShouldShow { shouldShowMarkTaskCompleteButton in
            if shouldShowMarkTaskCompleteButton {
                DispatchQueue.main.async {
                    self.subViewMarkTaskCompleteButton.addSubview(self.markTaskCompleteButton)
                    self.markTaskCompleteButton.center(inView: self.subViewMarkTaskCompleteButton)
                }
            }
        }
    }
    
    private func onViewModelDidSet(viewModel: TaskViewVM) {
        title = viewModel.contentTitle
        assignedUserLabel.text = viewModel.assignedUserString
        assignedTeamLabel.text = viewModel.assignedTeamString
        taskHistoryTitleLabel.attributedText = viewModel.taskHistoryTitleLabelText
        taskInformationButton.setTitle(viewModel.taskInformationButtonString, for: .normal)
        markTaskCompleteButton.setTitle(viewModel.taskCompleteButtonString, for: .normal)
        taskHistoryTable.reloadData()
    }
    
    private func configureTaskHistoryTableView() {
        taskHistoryTable.register(TaskViewEntryCell.self, forCellReuseIdentifier: TaskEntryCellReuseIdentifier)
        taskHistoryTable.rowHeight = 60
        taskHistoryTable.delegate = self
        taskHistoryTable.dataSource = self
    }
    
    // MARK: - Actions
    @objc func onTouchUpInsideTaskInformatioButton() {
        DispatchQueue.main.async {
            guard let task = self.viewModel?.task else { return }
            let newVc = TaskMoreInfoView()
            newVc.viewModel = TaskMoreInfoVM(task: task)
            self.present(newVc, animated: true)
        }
    }
    
    @objc func onTouchUpInsideMarkTaskCompleteButton() {
        guard let taskId = viewModel?.task.taskId else { return }
        TaskService.markTaskComplete(taskId: taskId) { task, error in
            DispatchQueue.main.async {
                if task != nil {
                    self.navigationController?.popViewController(animated: true)
                    self.requestHomeReload.send(true)
                } else if let error = error {
                    self.showMessage(withTitle: "Uh Oh", message: "Error Marking Task Complete: \(error)")
                } else {
                    self.showMessage(withTitle: "Uh Oh", message: "Error Marking Task Complete")
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension TaskView: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension TaskView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.taskEntries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskEntryCellReuseIdentifier, for: indexPath) as! TaskViewEntryCell
        if let taskHistoryItem = viewModel?.taskEntries[indexPath.row] {
            cell.viewModel = TaskViewEntryCellVM(taskEntry: taskHistoryItem)
        }
        
        return cell
    }
}
