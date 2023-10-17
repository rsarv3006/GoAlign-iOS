//
//  HomeScreen+TableView.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 10/16/23.
//

import UIKit

// MARK: - UITableViewDelegate
extension HomeScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        DispatchQueue.main.async {
            if tableView.tag == TASKTABLETAG {
                let taskVC = TaskViewScreen()
                taskVC.viewModel = TaskViewScreenVM(task: self.tasks[indexPath.row])
                taskVC.requestHomeReload.sink { _ in
                    self.viewModel?.loadTeams()
                    self.viewModel?.loadTasks()
                }.store(in: &self.subscriptions)
                self.navigationController?.pushViewController(taskVC, animated: true)
            } else if tableView.tag == TEAMTABLETAG {
                let groupTabVM = TeamTabBarControllerVM(team: self.teams[indexPath.row])

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
        if tableView.tag == TASKTABLETAG {
            return tasks.count
        } else if tableView.tag == TEAMTABLETAG {
            return teams.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == TASKTABLETAG {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TASKREUSEID,
                // swiftlint:disable:next force_cast
                for: indexPath) as! HomeScreenTaskCell
            cell.viewModel = HomeScreenTaskCellVM(withTask: tasks[indexPath.row])
            return cell
        } else if tableView.tag == TEAMTABLETAG {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TEAMREUSEID,
                // swiftlint:disable:next force_cast
                for: indexPath) as! HomeScreenTeamCell
            cell.viewModel = HomeScreenTeamCellVM(withTeam: teams[indexPath.row])
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "crash baby")
        }
    }

    func configureTableViews() {
        taskTableView.register(HomeScreenTaskCell.self, forCellReuseIdentifier: TASKREUSEID)
        taskTableView.rowHeight = 60
        taskTableView.delegate = self
        taskTableView.dataSource = self

        teamTableView.register(HomeScreenTeamCell.self, forCellReuseIdentifier: TEAMREUSEID)
        teamTableView.rowHeight = 60
        teamTableView.delegate = self
        teamTableView.dataSource = self
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint) -> UIContextMenuConfiguration? {
        if tableView.tag == TASKTABLETAG {
            let task = tasks[indexPath.row]
            return UIContextMenuConfiguration(
                identifier: task.taskId.uuidString as NSString,
                previewProvider: nil) { _ in
                let completeTask = UIAction(
                    title: "Complete Task",
                    image: UIImage(systemName: "checkmark.circle")) { _ in
                        if let taskEntryId = task.findCurrentTaskEntry()?.taskEntryId {
                            self.viewModel?.onMarkTaskComplete(viewController: self, taskEntryId: taskEntryId)

                        } else {
                            self.showMessage(withTitle: "Uh Oh", message: "Task Entry Not found.")
                        }
                    }
                return UIMenu(title: "", children: [completeTask])
            }
        } else if tableView.tag == TEAMTABLETAG {
            let team = teams[indexPath.row]
            return UIContextMenuConfiguration(
                identifier: team.teamId.uuidString as NSString,
                previewProvider: nil) { _ in
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
