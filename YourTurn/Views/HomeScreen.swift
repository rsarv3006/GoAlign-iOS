//
//  HomeScreen.swift
//  YourTurn
//
//  Created by rjs on 6/20/22.
//

import Foundation
import UIKit
import Combine

private let TASK_REUSE_ID = "TASK_REUSE_ID"
private let TEAM_REUSE_ID = "TEAM_REUSE_ID"
private let TASK_TABLE_TAG = 1001
private let TEAM_TABLE_TAG = 1002

class HomeScreen: UIViewController {
    // MARK: - Properties
    private var subscriptions = Set<AnyCancellable>()
    
    var logoutEventSubject = PassthroughSubject<Bool, Never>()
    
    var viewModel: HomeScreenVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            taskTitleLabel.attributedText = viewModel.taskTitleLabel
            teamTitleLabel.attributedText = viewModel.teamTitleLabel
        }
    }
    
    private var tasks = [TaskModel]() {
        didSet {
            taskTableView.reloadData()
        }
    }
    
    private var teams = [TeamModel]() {
        didSet {
            teamTableView.reloadData()
        }
    }
    
    private let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private let teamTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        let addImage = UIImage(systemName: "note.text.badge.plus")
        button.setImage(addImage, for: .normal)
        return button
    }()
    
    private let temporaryLogoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    private let taskTableView: UITableView = {
        let tv = UITableView()
        tv.tag = TASK_TABLE_TAG
        return tv
    }()
    
    private let teamTableView: UITableView = {
        let tv = UITableView()
        tv.tag = TEAM_TABLE_TAG
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureInteractables()
        configureTableViews()
        configureCombine()
    }
    
    // MARK: - Helpers
    private func configureView() {
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        let leftSafeAnchor = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeAnchor = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeAnchor = view.safeAreaLayoutGuide.bottomAnchor
        
        view.addSubview(taskTitleLabel)
        taskTitleLabel.centerX(inView: view, topAnchor: topSafeAnchor)
        
        view.addSubview(addTaskButton)
        addTaskButton.anchor(top: topSafeAnchor, right: rightSafeAnchor, paddingRight: 8)
        
        view.addSubview(temporaryLogoutButton)
        temporaryLogoutButton.anchor(top: topSafeAnchor, left: leftSafeAnchor, paddingLeft: 8)
        
        view.addSubview(teamTitleLabel)
        teamTitleLabel.center(inView: view)
        
        view.addSubview(taskTableView)
        taskTableView.anchor(top: taskTitleLabel.bottomAnchor, left: leftSafeAnchor, bottom: teamTitleLabel.topAnchor, right: rightSafeAnchor)
        
        view.addSubview(teamTableView)
        teamTableView.anchor(top: teamTitleLabel.bottomAnchor, left: leftSafeAnchor, bottom: bottomSafeAnchor, right: rightSafeAnchor)
        
    }
    
    private func configureInteractables() {
        addTaskButton.addTarget(self, action: #selector(onAddTaskPressed), for: .touchUpInside)
        temporaryLogoutButton.addTarget(self, action: #selector(onTempLogoutPressed), for: .touchUpInside)
    }
    
    private func configureCombine() {
        viewModel?.tasksSubject.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] incomingTasks in
            guard let self = self else { return }
            
            self.tasks = incomingTasks
        }).store(in: &subscriptions)
        
        viewModel?.teamsSubject.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] incomingTeams in
            guard let self = self else { return }
            self.teams = incomingTeams
        }).store(in: &subscriptions)
        
        viewModel?.loadTasks()
        viewModel?.loadTeams()
    }
    
    // MARK: - Actions
    @objc func onAddTaskPressed() {
        viewModel?.onAddTaskPress(navigationController: navigationController)
    }
    
    @objc func onTempLogoutPressed() {
        logoutEventSubject.send(true)
    }
}

// MARK: - UITableViewDelegate
extension HomeScreen: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension HomeScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == TASK_TABLE_TAG {
            return tasks.count
        } else if tableView.tag == TEAM_TABLE_TAG {
            return teams.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == TASK_TABLE_TAG {
            let cell = tableView.dequeueReusableCell(withIdentifier: TASK_REUSE_ID, for: indexPath) as! HomeScreenTaskCell
            cell.viewModel = HomeScreenTaskCellVM(withTask: tasks[indexPath.row])
            return cell
        } else if tableView.tag == TEAM_TABLE_TAG {
            let cell = tableView.dequeueReusableCell(withIdentifier: TEAM_REUSE_ID, for: indexPath) as! HomeScreenTeamCell
            cell.viewModel = HomeScreenTeamCellVM(withTeam: teams[indexPath.row])
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "crash baby")
        }
    }
    
    func configureTableViews() {
        taskTableView.register(HomeScreenTaskCell.self, forCellReuseIdentifier: TASK_REUSE_ID)
        taskTableView.rowHeight = 60
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        teamTableView.register(HomeScreenTeamCell.self, forCellReuseIdentifier: TEAM_REUSE_ID)
        teamTableView.rowHeight = 60
        teamTableView.delegate = self
        teamTableView.dataSource = self
    }
    
}
