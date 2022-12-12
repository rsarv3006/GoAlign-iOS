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
    
    private lazy var subViewTaskCompletionBox: UIView = {
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
    
    private lazy var taskCompleteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 18)
        return label
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
        
        view.addSubview(subViewTaskCompletionBox)
        subViewTaskCompletionBox.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor, height: 44)
        
        view.addSubview(assignedUserLabel)
        assignedUserLabel.anchor(top: subViewTaskCompletionBox.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(assignedTeamLabel)
        assignedTeamLabel.anchor(top: assignedUserLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(taskInformationButton)
        taskInformationButton.anchor(top: assignedTeamLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        view.addSubview(taskHistoryTitleLabel)
        taskHistoryTitleLabel.centerX(inView: view, topAnchor: taskInformationButton.bottomAnchor, paddingTop: 24)
        
        view.addSubview(taskHistoryTable)
        taskHistoryTable.anchor(top: taskHistoryTitleLabel.bottomAnchor, left: safeAreaLeftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: safeAreaRightAnchor, paddingLeft: 8, paddingRight: 8)
        
        configureTaskCompletionBox()
    }
    
    private func configureTaskCompletionBox() {
        guard let viewModel = viewModel else { return }
        viewModel.checkIfMarkTaskCompleteButtonShouldShow { shouldShowMarkTaskCompleteButton in
            if shouldShowMarkTaskCompleteButton {
                DispatchQueue.main.async {
                    self.subViewTaskCompletionBox.addSubview(self.markTaskCompleteButton)
                    self.markTaskCompleteButton.center(inView: self.subViewTaskCompletionBox)
                }
            } else if viewModel.isTaskCompleted == true {
                DispatchQueue.main.async {
                    self.subViewTaskCompletionBox.addSubview(self.taskCompleteLabel)
                    self.taskCompleteLabel.center(inView: self.subViewTaskCompletionBox)
                    self.taskCompleteLabel.text = viewModel.taskIsCompleteLabelString
                }
            }
        }
    }
    
    private func onViewModelDidSet(viewModel: TaskViewVM) {
        title = viewModel.contentTitle
        assignedUserLabel.text = viewModel.assignedUserString
        taskHistoryTitleLabel.attributedText = viewModel.taskHistoryTitleLabelText
        taskInformationButton.setTitle(viewModel.taskInformationButtonString, for: .normal)
        markTaskCompleteButton.setTitle(viewModel.taskCompleteButtonString, for: .normal)
        taskHistoryTable.reloadData()
        
        viewModel.teamNameSubject.sink { [weak self] teamNameResult in
            switch(teamNameResult) {
            case .failure(let error):
                self?.showMessage(withTitle: "Uh Oh", message: "Error fetching teamname. Error: \(error)")
            case .success(let teamName):
                DispatchQueue.main.async {
                    self?.assignedTeamLabel.text = teamName
                }
            }
            
        }.store(in: &subscriptions)
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
