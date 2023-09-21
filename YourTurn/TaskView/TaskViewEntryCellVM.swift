//
//  TaskViewEntryCellVM.swift
//  YourTurn
//
//  Created by Robby on 10/6/22.
//

import Foundation

class TaskViewEntryCellVM {
    let completedByLabelString: String
    let dateCompletedLabelString: String
    
    init(taskEntry: TaskEntryModel) {
        self.completedByLabelString = "Completed by: \(taskEntry.assignedUser.username)"
        self.dateCompletedLabelString = TaskViewEntryCellVM.createDateLabelString(date: taskEntry.completedDate)
    }
    
    static func createDateLabelString(date: Date?) -> String {
        guard let date else { return "" }
        
        return "Date Completed: \(String(describing: date.formatted()))"
    }
}
