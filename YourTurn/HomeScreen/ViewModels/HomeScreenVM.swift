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
    
    var loadViewControllerSubject = PassthroughSubject<UIViewController, Never>()
    
    let taskTitleLabel: NSAttributedString = NSAttributedString(string: "My Tasks",
                                                                attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    let teamTitleLabel: NSAttributedString = NSAttributedString(string: "My Groups",
                                                                attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    
    var tasksSubject = PassthroughSubject<Result<TaskModelArray, Error>, Never>()
    
    var teamsSubject = PassthroughSubject<Result<[TeamModel], Error>, Never>()
    
    func loadTasks() {
        Task {
            do {
                let tasks = try await TaskService.getTasksByAssignedUserId()
                
                tasksSubject.send(.success(tasks.filter({ task in
                    if task.status != .completed {
                        return true
                    } else {
                        return false
                    }
                })))
                
            } catch {
                tasksSubject.send(.failure(error))
            }
        }
    }
    
    func loadTeams() {
        Task {
            do {
                let teams = try await TeamService.getTeamsByCurrentUser()
                teamsSubject.send(.success(teams))
            } catch {
                teamsSubject.send(.failure(error))
            }
        }
    }
    
    func onAddTaskPress(navigationController: UINavigationController?) {
        let newVc = TaskAddEditScreen()
        newVc.viewModel = TaskAddEditScreenVM()
        newVc.delegate = self
        navigationController?.pushViewController(newVc, animated: false)
    }
    
    func onAddTeamPress(navigationController: UINavigationController?) {
        let newVc = TeamAddModal()
        newVc.viewModel = TeamAddModalVM()
        newVc.delegate = self
        newVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController?.present(newVc, animated: true)
    }
    
    func onMarkTaskComplete(viewController: UIViewController, taskId: String) {
        Task {
            do {
                let _ = try await TaskService.markTaskComplete(taskId: taskId)
                self.loadTasks()
            } catch {
                await viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }
}

extension HomeScreenVM: TaskAddEditScreenDelegate {
    func onTaskScreenComplet(viewController: UIViewController) {
        loadTasks()
        loadTeams()
    }
}

extension HomeScreenVM: TeamAddModalDelegate {
    func onTeamAddScreenComplete(viewController: UIViewController) {
        loadTasks()
        loadTeams()
    }
    
    func onTeamAddGoToInvite(viewController: UIViewController, teamId: String) {
        loadTasks()
        loadTeams()
        
        DispatchQueue.main.async {
            let newVC = TeamInviteUserModal()
            newVC.viewModel = TeamInviteUserModalVM(teamId: teamId)
            self.loadViewControllerSubject.send(newVC)
        }
        
    }
}
