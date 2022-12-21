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

class HomeScreen: YtViewController {
    // MARK: - Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private let taskRefreshControl = UIRefreshControl()
    private let teamRefreshControl = UIRefreshControl()
    
    var logoutEventSubject = PassthroughSubject<Bool, Never>()
    
    var viewModel: HomeScreenVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            taskTitleLabel.attributedText = viewModel.taskTitleLabel
            teamTitleLabel.attributedText = viewModel.teamTitleLabel
            
            viewModel.loadViewControllerSubject.sink { viewController in
                self.navigationController?.present(viewController, animated: true)
            }.store(in: &subscriptions)
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
    
    private lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var teamTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        let addImage = UIImage(systemName: "note.text.badge.plus", withConfiguration: configuration)
        button.setImage(addImage, for: .normal)
        return button
    }()
    
    private lazy var addTeamButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        let addImage = UIImage(systemName: "plus.square.on.square", withConfiguration: configuration)
        button.setImage(addImage, for: .normal)
        return button
    }()
    
    private let drawerButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        let drawerImage = UIImage(systemName: "line.3.horizontal", withConfiguration: configuration)
        button.setImage(drawerImage, for: .normal)
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
        showLoader(true)
        configureInteractables()
        configureTableViews()
        configureCombine()
        configureRefreshControl()
        
        Task {
            let token = try? await AuthenticationService.getToken()
            print(token ?? "UH OH NO TOKEN FOUND")
        }
    }
    
    // MARK: - Helpers
    override func configureView() {
        view.backgroundColor = .systemBackground
        
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        let leftSafeAnchor = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeAnchor = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeAnchor = view.safeAreaLayoutGuide.bottomAnchor
        
        view.addSubview(taskTitleLabel)
        taskTitleLabel.centerX(inView: view, topAnchor: topSafeAnchor)
        
        view.addSubview(addTaskButton)
        addTaskButton.anchor(top: topSafeAnchor, right: rightSafeAnchor, paddingRight: 8)
        
        view.addSubview(drawerButton)
        drawerButton.anchor(top: topSafeAnchor, left: leftSafeAnchor, paddingLeft: 8)
        
        view.addSubview(teamTitleLabel)
        teamTitleLabel.center(inView: view)
        
        view.addSubview(addTeamButton)
        addTeamButton.centerY(inView: view)
        addTeamButton.anchor(right: rightSafeAnchor, paddingRight: 12)
        
        view.addSubview(taskTableView)
        taskTableView.anchor(top: taskTitleLabel.bottomAnchor, left: leftSafeAnchor, bottom: teamTitleLabel.topAnchor, right: rightSafeAnchor, paddingLeft: 8, paddingRight: 8)
        
        view.addSubview(teamTableView)
        teamTableView.anchor(top: teamTitleLabel.bottomAnchor, left: leftSafeAnchor, bottom: bottomSafeAnchor, right: rightSafeAnchor, paddingLeft: 8, paddingRight: 8)
        
    }
    
    private func configureRefreshControl() {
        taskRefreshControl.addTarget(self, action: #selector(onTaskReloadRequested), for: .valueChanged)
        taskTableView.refreshControl = taskRefreshControl
        
        teamRefreshControl.addTarget(self, action: #selector(onTeamReloadRequested), for: .valueChanged)
        teamTableView.refreshControl = teamRefreshControl
    }
    
    @objc func onTaskReloadRequested() {
        viewModel?.loadTasks()
    }
    
    @objc func onTeamReloadRequested() {
        viewModel?.loadTeams()
    }
    
    private func configureInteractables() {
        addTaskButton.addTarget(self, action: #selector(onAddTaskPressed), for: .touchUpInside)
        drawerButton.addTarget(self, action: #selector(onDrawerButtonPress), for: .touchUpInside)
        addTeamButton.addTarget(self, action: #selector(onAddTeamPressed), for: .touchUpInside)
    }
    
    private func configureCombine() {
        viewModel?.tasksSubject.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] tasksResult in
            self?.showLoader(false)
            self?.taskRefreshControl.endRefreshing()
            guard let self = self else { return }
            
            switch (tasksResult) {
            case .failure(let error):
                self.showMessage(withTitle: "Uh Oh", message: "Error encountered retrieving tasks. \(error.localizedDescription)")
            case .success(let incomingTasks):
                self.tasks = incomingTasks
            }
            
        }).store(in: &subscriptions)
        
        viewModel?.teamsSubject.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] teamsResult in
            self?.showLoader(false)
            self?.teamRefreshControl.endRefreshing()
            guard let self = self else { return }
            switch (teamsResult) {
            case .failure(let error):
                self.showMessage(withTitle: "Uh Oh", message: "Error encountered retrieving teams. \(error.localizedDescription)")
            case .success(let incomingTeams):
                self.teams = incomingTeams
            }
            
        }).store(in: &subscriptions)
        
        viewModel?.loadTasks()
        viewModel?.loadTeams()
    }
    
    // MARK: - Actions
    @objc func onAddTaskPressed() {
        viewModel?.onAddTaskPress(navigationController: navigationController)
    }
    
    @objc func onAddTeamPressed() {
        viewModel?.onAddTeamPress(navigationController: navigationController)
    }
    
    @objc func onDrawerButtonPress() {
        let drawerController = DrawerMenuViewController()
        drawerController.delegate = self
        present(drawerController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension HomeScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        DispatchQueue.main.async {
            if tableView.tag == TASK_TABLE_TAG {
                let taskVC = TaskView()
                taskVC.viewModel = TaskViewVM(task: self.tasks[indexPath.row])
                taskVC.requestHomeReload.sink { _ in
                    self.viewModel?.loadTeams()
                    self.viewModel?.loadTasks()
                }.store(in: &self.subscriptions)
                self.navigationController?.pushViewController(taskVC, animated: true)
            } else if tableView.tag == TEAM_TABLE_TAG {
                let groupTabVM = TeamTabBarVM(team: self.teams[indexPath.row])
                
                groupTabVM.requestHomeReload.sink { _ in
                    self.viewModel?.loadTeams()
                    self.viewModel?.loadTasks()
                }.store(in: &self.subscriptions)
                
                let groupTabVC = TeamTabBarController()
                groupTabVC.viewModel = groupTabVM
                self.navigationController?.pushViewController(groupTabVC, animated: true)
            }
        }
        
        
        return nil
    }
}

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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if tableView.tag == TASK_TABLE_TAG {
            let task = tasks[indexPath.row]
            return UIContextMenuConfiguration(identifier: task.taskId as NSString, previewProvider: nil) { _ in
                let completeTask = UIAction(
                    title: "Complete Task",
                    image: UIImage(systemName: "checkmark.circle")) { _ in
                        self.viewModel?.onMarkTaskComplete(viewController: self, taskId: task.taskId)
                    }
                return UIMenu(title: "", children: [completeTask])
            }
        } else if tableView.tag == TEAM_TABLE_TAG {
            let team = teams[indexPath.row]
            return UIContextMenuConfiguration(identifier: team.teamId as NSString, previewProvider: nil) { _ in
                let completeTask = UIAction(
                    title: "Team Thing",
                    image: UIImage(systemName: "checkmark.circle")) { _ in
                        // share the task
                    }
                return UIMenu(title: "", children: [completeTask])
            }
        }
        
        return nil
    }
    
}

// MARK: - DrawerMenuViewControllerDelegate
extension HomeScreen: DrawerMenuViewControllerDelegate {
    func onViewSettingsPressed(viewController: UIViewController) {
        DispatchQueue.main.async {
            let newVc = SettingsScreenView()
            newVc.viewModel = SettingsScreenVM()
            
            newVc.deleteAccountReturnToSignIn.sink { val in
                self.logoutEventSubject.send(val)
            }.store(in: &self.subscriptions)
            
            self.navigationController?.pushViewController(newVc, animated: true)
        }
    }
    
    func onLogOutPressed(viewController: UIViewController) {
        logoutEventSubject.send(true)
    }
    
    func onViewTeamInvitesPressed(viewController: UIViewController) {
        DispatchQueue.main.async {
            let newVc = TeamInvitesViewController()
            newVc.viewModel = TeamInvitesVM()
            newVc.requestHomeReload.sink { _ in
                self.viewModel?.loadTeams()
                self.viewModel?.loadTasks()
            }.store(in: &self.subscriptions)
            self.navigationController?.pushViewController(newVc, animated: true)
        }
    }
}
