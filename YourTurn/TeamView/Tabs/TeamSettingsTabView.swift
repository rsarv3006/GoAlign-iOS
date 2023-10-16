//
//  GroupSettingsTabView.swift
//  YourTurn
//
//  Created by rjs on 11/6/22.
//

import UIKit
import Combine

private struct ReuseIdentifiers {
    static let DeleteTeam = "settingsDeleteTeamReuseIdentifier"
    static let LeaveTeam = "settingsLeaveTeamReuseIdentifier"
    static let ChangeTeamManager = "settingsChangeTeamManagerReuseIdentifier"
    static let AllMembersCanAddTasks = "allMembersCanAddTasksReuseIdentifier"
}
class TeamSettingsTabView: YtViewController {

    private var subscriptions = Set<AnyCancellable>()

    var viewModel: TeamSettingsTabVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            configureViewModelCombineSubjects(viewModel: viewModel)
        }
    }

    // MARK: UI Elements
    private lazy var settingsTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .customBackgroundColor
        return tv
    }()

    // MARK: LIFECYCLE
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .customBackgroundColor
        super.viewDidLoad()
    }

    // MARK: Helpers
    override func configureView() {
        settingsTableView.register(TeamSettingsDeleteTeamCell.self, forCellReuseIdentifier: ReuseIdentifiers.DeleteTeam)
        settingsTableView.register(TeamSettingsLeaveTeamCell.self, forCellReuseIdentifier: ReuseIdentifiers.LeaveTeam)
        settingsTableView.register(TeamSettingsChangeTeamManagerCell.self, forCellReuseIdentifier: ReuseIdentifiers.ChangeTeamManager)
        settingsTableView.register(TeamSettingsAllMembersCanAddTasksCell.self, forCellReuseIdentifier: ReuseIdentifiers.AllMembersCanAddTasks)

        settingsTableView.rowHeight = 48

        settingsTableView.delegate = self
        settingsTableView.dataSource = self

        view.addSubview(settingsTableView)
        settingsTableView.fillSuperview()

    }
}

// MARK: - UITableViewDataSource
extension TeamSettingsTabView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.settingsItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsVariant = viewModel?.settingsItems[indexPath.row]
        guard let settingsVariant = settingsVariant, let team = viewModel?.team else { fatalError("Settings load problem")}

        switch settingsVariant {
        case .DeleteTeam:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.DeleteTeam, for: indexPath) as! TeamSettingsDeleteTeamCell
            let cellVM = TeamSettingsDeleteTeamCellVM(team: team)
            cellVM.delegate = viewModel
            cell.viewModel = cellVM
            return cell
        case .LeaveTeam:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.LeaveTeam, for: indexPath) as! TeamSettingsLeaveTeamCell
            let cellVM = TeamSettingsLeaveTeamCellVM(team: team)
            cellVM.delegate = viewModel
            cell.viewModel = cellVM
            return cell
        case .ChangeTeamManager:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.ChangeTeamManager, for: indexPath) as! TeamSettingsChangeTeamManagerCell
            let cellVM = TeamSettingsChangeTeamManagerCellVM(withTeam: team)
            cellVM.delegate = viewModel
            cell.viewModel = cellVM
            return cell
        case .AllMembersCanAddTasks:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.AllMembersCanAddTasks, for: indexPath) as! TeamSettingsAllMembersCanAddTasksCell
            let cellVM = TeamSettingsAllMembersCanAddTasksCellVM(team: team)
            cellVM.delegate = viewModel
            cell.viewModel = cellVM
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - UITableViewDelegate
extension TeamSettingsTabView: UITableViewDelegate {

}

// MARK: Combine
extension TeamSettingsTabView {
    func configureViewModelCombineSubjects(viewModel: TeamSettingsTabVM) {
        viewModel.requestShowLoader.sink { isVisible in
            self.showLoader(isVisible)
        }.store(in: &subscriptions)

        viewModel.requestShowAlert.sink { alert in
            self.present(alert, animated: true)
        }.store(in: &subscriptions)

        viewModel.reloadTeamSettingsTable.sink { _ in
            DispatchQueue.main.async {
                self.settingsTableView.reloadData()
            }
        }.store(in: &subscriptions)

        viewModel.requestShowMessage.sink { message in
            self.showMessage(withTitle: message.title, message: message.message)
        }.store(in: &subscriptions)

        viewModel.requestShowModal.sink { viewController in
            self.navigationController?.present(viewController, animated: true)
        }.store(in: &subscriptions)
    }
}
