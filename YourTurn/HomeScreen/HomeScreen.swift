//
//  HomeScreen.swift
//  YourTurn
//
//  Created by rjs on 6/20/22.
//

import Foundation
import UIKit
import Combine

let TASKREUSEID = "TASK_REUSE_ID"
let TEAMREUSEID = "TEAM_REUSE_ID"
let TASKTABLETAG = 1001
let TEAMTABLETAG = 1002

class HomeScreen: YtViewController {
    // MARK: - Properties
    var subscriptions = Set<AnyCancellable>()

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

    var tasks = [TaskModel]() {
        didSet {
            taskTableView.reloadData()
        }
    }

    var teams = [TeamModel]() {
        didSet {
            teamTableView.reloadData()
        }
    }

    private lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .customTitleText
        return label
    }()

    private lazy var teamTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .customTitleText
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

    let taskTableView: UITableView = {
        let tvw = UITableView()
        tvw.tag = TASKTABLETAG
        tvw.backgroundColor = .customBackgroundColor
        return tvw
    }()

    let teamTableView: UITableView = {
        let tvw = UITableView()
        tvw.tag = TEAMTABLETAG
        tvw.backgroundColor = .customBackgroundColor
        return tvw
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(true)
        checkIfPurchasesHaveBeenMade()
        configureInteractables()
        configureTableViews()
        configureCombine()
        configureRefreshControl()

        viewModel?.checkAndDisplayPendingInviteBaner(viewController: self)

        store.$hasPurchasedMembership.sink { [weak self] hasPurchased in
            if hasPurchased {
                self?.taskTableView.reloadData()
                self?.teamTableView.reloadData()
            }
        }.store(in: &subscriptions)
    }

    // MARK: - Helpers
    override func configureView() {
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
        taskTableView.anchor(
            top: taskTitleLabel.bottomAnchor,
            left: leftSafeAnchor,
            bottom: teamTitleLabel.topAnchor,
            right: rightSafeAnchor,
            paddingLeft: 8,
            paddingRight: 8)

        view.addSubview(teamTableView)
        teamTableView.anchor(
            top: teamTitleLabel.bottomAnchor,
            left: leftSafeAnchor,
            bottom: bottomSafeAnchor,
            right: rightSafeAnchor,
            paddingLeft: 8,
            paddingRight: 8)

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

            switch tasksResult {
            case .failure(let error):
                _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                    self.showMessage(
                        withTitle: "Uh Oh",
                        message: "Error encountered retrieving tasks. \(error.localizedDescription)")
                }
            case .success(let incomingTasks):
                self.tasks = incomingTasks
            }

        }).store(in: &subscriptions)

        viewModel?.teamsSubject.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] teamsResult in
            self?.showLoader(false)
            self?.teamRefreshControl.endRefreshing()
            guard let self = self else { return }
            switch teamsResult {
            case .failure(let error):
                _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                    self.showMessage(
                        withTitle: "Uh Oh",
                        message: "Error encountered retrieving teams. \(error.localizedDescription)")
                }
            case .success(let incomingTeams):
                self.teams = incomingTeams
            }

        }).store(in: &subscriptions)

        viewModel?.loadTeamsAndTasks()

        AppState.signOutRequestPublisher.receive(on: DispatchQueue.main).sink { [weak self] _ in
            if let self {
                self.onLogOutPressed(viewController: self)
            }
        }.store(in: &subscriptions)

    }

    // MARK: - Actions
    @objc func onAddTaskPressed() {
        onAddTaskPress()
    }

    @objc func onAddTeamPressed() {
        onAddTeamPress()
    }

    @objc func onDrawerButtonPress() {
        let drawerController = DrawerMenuViewController()
        drawerController.delegate = self
        present(drawerController, animated: true)
    }

    private func checkIfPurchasesHaveBeenMade() {
        Task {
            showLoader(true)
            await store.updateCustomerProductStatus()
            showLoader(false)
        }
    }
}

// MARK: - Navigation Handling
extension HomeScreen {
    func onAddTaskPress() {
        let newVC = TaskAddEditScreen()
        newVC.viewModel = TaskAddEditScreenVM()
        newVC.delegate = self
        navigationController?.pushViewController(newVC, animated: true)
    }

    func onAddTeamPress() {
        let newVC = TeamAddModal()
        newVC.viewModel = TeamAddModalVM()
        newVC.delegate = self
        navigationController?.present(newVC, animated: true)
    }
}

// MARK: TeamAddModalDelegate
extension HomeScreen: TeamAddModalDelegate {
    func onTeamAddScreenComplete(viewController: UIViewController) {
        viewModel?.loadTeamsAndTasks()
    }

    func onTeamAddGoToInvite(viewController: UIViewController, teamId: UUID) {
        viewModel?.loadTeamsAndTasks()

        DispatchQueue.main.async {
            let newVC = TeamInviteUserModal()
            newVC.viewModel = TeamInviteUserModalVM(teamId: teamId)
            self.navigationController?.present(newVC, animated: true)
        }
    }
}

// MARK: - TaskAddEditScreenDelegate
extension HomeScreen: TaskAddEditScreenDelegate {
    func onTaskScreenComplet(viewController: UIViewController) {
        viewModel?.loadTeamsAndTasks()
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
                self.viewModel?.loadTeamsAndTasks()
            }.store(in: &self.subscriptions)
            self.navigationController?.pushViewController(newVc, animated: true)
        }
    }

    func onViewLegalScreenPressed(viewController: UIViewController) {
        DispatchQueue.main.async {
            let newVc = LegalScreen()
            self.navigationController?.pushViewController(newVc, animated: true)
        }
    }
}
