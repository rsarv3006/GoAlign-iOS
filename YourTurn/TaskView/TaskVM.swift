//
//  TaskVM.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import Foundation

class TaskVM {
    let contentTitle: String
    let assignedUserString: String
    let assignedTeamString: String
    let taskHistoryItems: [TaskHistoryItem]
    
    init(task: TaskModel) {
        self.contentTitle = task.taskName
        self.assignedUserString = task.assignedUser?.username ?? ""
        // TODO: - Need to attach team object to getTask
        self.assignedTeamString = task.teamId
        self.taskHistoryItems = task.taskHistoryItems ?? []
    }
    
    
}
