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
    
    var isTaskComplete: Bool {
        get {
            task.status == "completed"
        }
    }
    
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
                self.task = try await TaskService.getTaskByTaskId(taskId: task.taskId)
                resetView.send(nil)
            } catch {
                resetView.send(error)
            }
        }
    }
    
    func deleteTask() async throws {
        try await TaskService.deleteTask(taskId: task.taskId)
    }
    
}
