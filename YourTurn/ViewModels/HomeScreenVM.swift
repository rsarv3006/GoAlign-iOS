//
//  HomeScreenVM.swift
//  YourTurn
//
//  Created by rjs on 6/21/22.
//

import Foundation
import Combine

class HomeScreenVM {
    var subscriptions = Set<AnyCancellable>()
    
    var taskTitleLabel: String = "My Tasks"
    var teamTitleLabel: String = "My Groups"
    
    var tasksSubject = PassthroughSubject<[GqlTasksByAssignedUserIdTaskObject], Never>()
    
    var teamsSubject = PassthroughSubject<[GqlTeamsByUserIdTeamObject], Never>()
    
    func loadTasks(userId: String) {
        Network.shared.apollo.fetch(query: TasksByAssignedUserIdQuery(userId: userId)) { [weak self] result in
            guard let self = self else { return }
            print("DEBUG: hi from shared apollo")
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
            print("DEBUG: hi from shared apollo")
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
}
