//
//  GroupView.swift
//  YourTurn
//
//  Created by rjs on 11/5/22.
//

import UIKit
import Combine

class TeamTabBarController: UITabBarController {

    var subscriptions = Set<AnyCancellable>()

    var viewModel: TeamTabBarControllerVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            configureViewControllers(viewModel: viewModel)
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Helpers
    func configureViewControllers(viewModel: TeamTabBarControllerVM) {
        self.delegate = self

        let teamTasksTabViewController = configureTaskTab(viewModel: viewModel)
        let teamUsersTabViewController = configureUsersTab(viewModel: viewModel)
        let teamStatsTabViewController = configureStatsTab(viewModel: viewModel)
        let teamSettingsTabViewController = configureSettingsTab(viewModel: viewModel)

        viewControllers = [
            teamTasksTabViewController,
            teamUsersTabViewController,
            teamStatsTabViewController,
            teamSettingsTabViewController]
        tabBar.tintColor = .customAccentColor
        tabBar.backgroundColor = .customBackgroundColor
    }

    func templateNavigationController(
        unSelectedImage: UIImage,
        selectedImage: UIImage,
        rootViewController: UIViewController,
        title: String? = nil) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unSelectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title

        nav.navigationBar.tintColor = .black

        return nav
    }

}

// MARK: - UITabCarControllerDelegate
extension TeamTabBarController: UITabBarControllerDelegate {}

private extension TeamTabBarController {
    func configureTaskTab(viewModel: TeamTabBarControllerVM) -> UIViewController {
        let teamTasksTabViewImage = (UIImage(systemName: "list.bullet.rectangle"))!

        let teamTasksTabVM = TeamTasksTabVM(team: viewModel.team)
        teamTasksTabVM.requestHomeReload = viewModel.requestHomeReload

        let teamTasksTabView = TeamTasksTabView()
        teamTasksTabView.viewModel = teamTasksTabVM

        let teamTasksTabViewController =
        templateNavigationController(
            unSelectedImage: teamTasksTabViewImage,
            selectedImage: teamTasksTabViewImage,
            rootViewController: teamTasksTabView,
            title: "Tasks")

        return teamTasksTabViewController
    }

    func configureUsersTab(viewModel: TeamTabBarControllerVM) -> UIViewController {
        let teamUsersTabViewImage = (UIImage(systemName: "person.2.fill"))!
        let teamUsersTabVM = TeamUsersTabVM(team: viewModel.team)

        let teamUsersTabView = TeamUsersTabView()
        teamUsersTabView.viewModel = teamUsersTabVM

        let teamUsersTabViewController =
        templateNavigationController(
            unSelectedImage: teamUsersTabViewImage,
            selectedImage: teamUsersTabViewImage,
            rootViewController: teamUsersTabView,
            title: "Users")

        return teamUsersTabViewController
    }

    func configureStatsTab(viewModel: TeamTabBarControllerVM) -> UIViewController {
        let teamStatsTabViewImage = (UIImage(systemName: "chart.bar.xaxis"))!
        let teamStatsTabVM = TeamStatsTabVM(teamId: viewModel.team.teamId)

        let teamStatsTabView = TeamStatsTabView()
        teamStatsTabView.viewModel = teamStatsTabVM

        let teamStatsTabViewController =
        templateNavigationController(
            unSelectedImage: teamStatsTabViewImage,
            selectedImage: teamStatsTabViewImage,
            rootViewController: teamStatsTabView,
            title: "Stats")

        return teamStatsTabViewController
    }

    func configureSettingsTab(viewModel: TeamTabBarControllerVM) -> UIViewController {
        let teamSettingsTabViewImage = (UIImage(systemName: "gear.circle"))!
        let teamSettingsTabVM = TeamSettingsTabVM(team: viewModel.team)

        let teamSettingsTabView = TeamSettingsTabView()
        teamSettingsTabVM.requestHomeReload = viewModel.requestHomeReload

        teamSettingsTabView.viewModel = teamSettingsTabVM

        teamSettingsTabVM.requestRemoveTabView.sink { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }.store(in: &subscriptions)

        let teamSettingsTabViewController =
        templateNavigationController(
            unSelectedImage: teamSettingsTabViewImage,
            selectedImage: teamSettingsTabViewImage,
            rootViewController: teamSettingsTabView,
            title: "Settings")

        return teamSettingsTabViewController
    }
}
