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

    var teamsSubject = PassthroughSubject<[TeamModel], Never>()
    
    func loadTasks() {
        TaskService.getTasksByAssignedUserId { [weak self] tasks, error in
            guard let tasks = tasks else {
                Logger.log(logLevel: .Prod, message: "\(String(describing: error))")
                return
            }
            self?.tasksSubject.send(tasks)
        }
    }
    
    func loadTeams() {
        TeamService.getTeamsbyCurrentUser { [weak self] teams, error in
            guard let teams = teams else {
                Logger.log(logLevel: .Prod, message: "\(String(describing: error))")
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
    
}
