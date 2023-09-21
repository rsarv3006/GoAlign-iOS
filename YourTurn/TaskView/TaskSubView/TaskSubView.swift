//
//  TaskSubView.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/3/23.
//

import UIKit
import Combine

let TaskEntryCellReuseIdentifier = "TaskEntryCellReuseIdentifier"

class TaskSubView: UIView {
    
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: TaskSubViewVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelDidSet(viewModel: viewModel)
        }
    }
    
    // MARK: UI Elements
    private lazy var assignedUserLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()
    
    private lazy var assignedTeamLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()
    
    private lazy var taskHistoryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .customTitleText
        return label
    }()
    
    private lazy var taskHistoryTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .customBackgroundColor
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
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureView() {
        let safeAreaTopAnchor = self.safeAreaLayoutGuide.topAnchor
        let safeAreaBottomAnchor = self.safeAreaLayoutGuide.bottomAnchor
        let safeAreaLeftAnchor = self.safeAreaLayoutGuide.leftAnchor
        let safeAreaRightAnchor = self.safeAreaLayoutGuide.rightAnchor
        
        self.backgroundColor = .customBackgroundColor
        
        taskInformationButton.addTarget(self, action: #selector(onTouchUpInsideTaskInformatioButton), for: .touchUpInside)
        
        self.addSubview(subViewTaskCompletionBox)
        subViewTaskCompletionBox.anchor(top: safeAreaTopAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor, height: 44)
        
        self.addSubview(assignedUserLabel)
        assignedUserLabel.anchor(top: subViewTaskCompletionBox.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor, paddingTop: 8, paddingLeft: 8)
        
        self.addSubview(assignedTeamLabel)
        assignedTeamLabel.anchor(top: assignedUserLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor, paddingLeft: 8)
        
        self.addSubview(taskInformationButton)
        taskInformationButton.anchor(top: assignedTeamLabel.bottomAnchor, left: safeAreaLeftAnchor, right: safeAreaRightAnchor)
        
        self.addSubview(taskHistoryTitleLabel)
        taskHistoryTitleLabel.centerX(inView: self, topAnchor: taskInformationButton.bottomAnchor, paddingTop: 24)
        
        self.addSubview(taskHistoryTable)
        taskHistoryTable.anchor(top: taskHistoryTitleLabel.bottomAnchor, left: safeAreaLeftAnchor, bottom: safeAreaBottomAnchor, right: safeAreaRightAnchor, paddingLeft: 8, paddingRight: 8)
        
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
    
    private func onViewModelDidSet(viewModel: TaskSubViewVM) {
        configureView()
        configureTaskHistoryTableView()
        
        assignedUserLabel.text = viewModel.assignedUserString
        taskHistoryTitleLabel.attributedText = viewModel.taskHistoryTitleLabelText
        taskInformationButton.setTitle(viewModel.taskInformationButtonString, for: .normal)
        markTaskCompleteButton.setTitle(viewModel.taskCompleteButtonString, for: .normal)
        taskHistoryTable.reloadData()
        
        viewModel.teamNameSubject.sink { [weak self] teamNameResult in
            switch(teamNameResult) {
            case .failure(let error):
                viewModel.delegate?.requestShowMessage(withTitle: "Uh Oh", message: "Error fetching teamname. \(error.localizedDescription)")
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
            self.viewModel?.delegate?.requestPresentViewController(newVc)
        }
    }
    
    // MARK: Actions
    @objc func onTouchUpInsideMarkTaskCompleteButton() {
        viewModel?.onRequestMarkTaskComplete()
    }
}

// MARK: - UITableViewDelegate
extension TaskSubView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - UITableViewDataSource
extension TaskSubView: UITableViewDataSource {
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
