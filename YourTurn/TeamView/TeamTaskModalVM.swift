//
//  TeamTaskModalVM.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/4/23.
//

import Foundation
import Combine

class TeamTaskModalVM {
    var requestRefreshTeam = PassthroughSubject<Bool, Never>()
    private(set) var isUserTeamManager = CurrentValueSubject<Bool, Never>(false)
    private(set) var resetView = PassthroughSubject<Error?, Never>()
    
    var contentTitle: String {
        get {
            task.taskName
        }
    }
    private(set) var task: TaskModel
    
    init(task: TaskModel) {
        self.task = task
        
        checkIsUserTeamManager()
    }
    
    func checkIsUserTeamManager() {
        Task {
            do {
                let isTeamManager = try? await UserService.isUserTeamManager(forTeamById: task.teamId)
                if isTeamManager == true {
                    isUserTeamManager.send(true)
                }
            }
        }
    }
    
    func refetchTeam() {
        Task {
            do {
                let task = try await TaskService.getTasksByTaskIds(taskIds: [task.taskId])
                self.task = task[0]
                resetView.send(nil)
            } catch {
                resetView.send(error)
            }
        }
    }
}
