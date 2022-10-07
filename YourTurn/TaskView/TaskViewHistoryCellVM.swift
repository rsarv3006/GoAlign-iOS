//
//  TaskViewHistoryCellVM.swift
//  YourTurn
//
//  Created by Robby on 10/6/22.
//

import Foundation

struct TaskViewHistoryCellVM {
    let completedByLabelString: String
    let dateCompletedLabelString: String
    
    init(taskHistoryItem: TaskHistoryItem) {
        self.completedByLabelString = "Completed by: \(taskHistoryItem.assignedUserId)"
        self.dateCompletedLabelString = "Date Completed: \(taskHistoryItem.dateCompleted.ISO8601Format())"
    }
}
