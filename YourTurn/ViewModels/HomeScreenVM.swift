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
    var subscriptions = Set<AnyCancellable>()
    
    var taskTitleLabel: NSAttributedString = NSAttributedString(string: "My Tasks",
                                                     attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    var teamTitleLabel: NSAttributedString = NSAttributedString(string: "My Groups",
                                                    attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    
    var tasksSubject = PassthroughSubject<[GqlTasksByAssignedUserIdTaskObject], Never>()
    
    var teamsSubject = PassthroughSubject<[GqlTeamsByUserIdTeamObject], Never>()
    
    func loadTasks(userId: String) {
        Network.shared.apollo.fetch(query: TasksByAssignedUserIdQuery(userId: userId)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                if let tasksData = graphQLResult.data?.getTasksByAssignedUserId {
                    self.tasksSubject.send(tasksData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadTeams(userId: String) {
        Network.shared.apollo.fetch(query: GetTeamsByUserIdQuery(userId: userId)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                if let teamsData = graphQLResult.data?.getTeamsByUserId {
                    self.teamsSubject.send(teamsData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func onAddTaskPress(navigationController: UINavigationController?) {
        let newVc = TaskAddEditScreen()
        newVc.viewModel = TaskAddEditScreenVM()
        navigationController?.pushViewController(newVc, animated: false)
    }
}
