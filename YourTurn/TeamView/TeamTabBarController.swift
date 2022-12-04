//
//  GroupView.swift
//  YourTurn
//
//  Created by rjs on 11/5/22.
//

import UIKit
import Firebase
import Combine

class TeamTabBarController: UITabBarController {
    
    var subscriptions = Set<AnyCancellable>()
    
    var viewModel: TeamTabBarVM? {
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
    func configureViewControllers(viewModel: TeamTabBarVM) {
        view.backgroundColor = .systemBackground
        self.delegate = self
        
        let teamTasksTabViewController = configureTaskTab(viewModel: viewModel)
        let teamUsersTabViewController = configureUsersTab(viewModel: viewModel)
        let teamStatsTabViewController = configureStatsTab(viewModel: viewModel)
        let teamSettingsTabViewController = configureSettingsTab(viewModel: viewModel)
        
        viewControllers = [teamTasksTabViewController, teamUsersTabViewController, teamStatsTabViewController, teamSettingsTabViewController]
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .white
    }
    
    func templateNavigationController(unSelectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController, title: String? = nil) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unSelectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title

        nav.navigationBar.tintColor = .black
        
        return nav
    }

}

//MARK: - UITabCarControllerDelegate
extension TeamTabBarController: UITabBarControllerDelegate {}

private extension TeamTabBarController {
    func configureTaskTab(viewModel: TeamTabBarVM) -> UIViewController {
        let teamTasksTabViewImage = (UIImage(systemName: "list.bullet.rectangle"))!
        
        let teamTasksTabVM = TeamTasksTabVM(team: viewModel.team)
        
        let teamTasksTabView = TeamTasksTabView()
        teamTasksTabView.viewModel = teamTasksTabVM
        
        let teamTasksTabViewController = templateNavigationController(unSelectedImage: teamTasksTabViewImage, selectedImage: teamTasksTabViewImage, rootViewController: teamTasksTabView, title: "Tasks")
        
        return teamTasksTabViewController
    }
    
    func configureUsersTab(viewModel: TeamTabBarVM) -> UIViewController {
        let teamUsersTabViewImage = (UIImage(systemName: "person.2.fill"))!
        let teamUsersTabVM = TeamUsersTabVM(team: viewModel.team)
        
        let teamUsersTabView = TeamUsersTabView()
        teamUsersTabView.viewModel = teamUsersTabVM
        
        let teamUsersTabViewController = templateNavigationController(unSelectedImage: teamUsersTabViewImage, selectedImage: teamUsersTabViewImage, rootViewController: teamUsersTabView, title: "Users")
        
        return teamUsersTabViewController
    }
    
    func configureStatsTab(viewModel: TeamTabBarVM) -> UIViewController {
        let teamStatsTabViewImage = (UIImage(systemName: "chart.bar.xaxis"))!
        let teamStatsTabVM = TeamStatsTabVM(teamId: viewModel.team.teamId)
        
        let teamStatsTabView = TeamStatsTabView()
        teamStatsTabView.viewModel = teamStatsTabVM
        
        let teamStatsTabViewController = templateNavigationController(unSelectedImage: teamStatsTabViewImage, selectedImage: teamStatsTabViewImage, rootViewController: teamStatsTabView, title: "Stats")
        
        return teamStatsTabViewController
    }
    
    func configureSettingsTab(viewModel: TeamTabBarVM) -> UIViewController {
        let teamSettingsTabViewImage = (UIImage(systemName: "gear.circle"))!
        
        let teamSettingsTabViewController = templateNavigationController(unSelectedImage: teamSettingsTabViewImage, selectedImage: teamSettingsTabViewImage, rootViewController: TeamSettingsTabView(), title: "Settings")
        
        return teamSettingsTabViewController
    }
}

