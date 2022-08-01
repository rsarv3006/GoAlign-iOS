//
//  HomeScreenVM.swift
//  YourTurn
//
//  Created by rjs on 6/21/22.
//

import Foundation
import Combine
import UIKit

class HomeScreenVM {
    private(set) var subscriptions = Set<AnyCancellable>()
    
    let taskTitleLabel: NSAttributedString = NSAttributedString(string: "My Tasks",
                                                     attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    let teamTitleLabel: NSAttributedString = NSAttributedString(string: "My Groups",
                                                    attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    
    var tasksSubject = PassthroughSubject<TaskModelArray, Never>()
//    
    var teamsSubject = PassthroughSubject<[TeamModel], Never>()
    
    var authCompleteDismissView = PassthroughSubject<Bool, Never>()
    
    func loadTasks() {
        TaskService.getTasksByAssignedUserId { [weak self] tasks, error in
            guard let tasks = tasks else {
                print(String(describing: error))
                return
            }
            self?.tasksSubject.send(tasks)
        }
    }
    
    func loadTeams() {
        TeamService.getTeamsbyCurrentUser { [weak self] teams, error in
            guard let teams = teams else {
                print(String(describing: error))
                return
            }
            
            self?.teamsSubject.send(teams)

        }
    }
    
    func onAddTaskPress(navigationController: UINavigationController?) {
        let newVc = TaskAddEditScreen()
        newVc.viewModel = TaskAddEditScreenVM()
        navigationController?.pushViewController(newVc, animated: false)
    }
    
    func checkIfUserIsLoggedIn(navigationController: UINavigationController?) {
        if !AuthenticationService.doesCurrentUserExist() {
            DispatchQueue.main.async {
                let controller = SignUpScreen()
                let signUpVM = SignUpVM()
                controller.viewModel = signUpVM
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                navigationController?.present(nav, animated: false, completion: nil)
            }
            
        }

    }
}

extension HomeScreenVM: SignUpScreenDelegate {
    func authenticationDidComplete(viewController: UIViewController) {
        authCompleteDismissView
            .send(true)
    }
}
