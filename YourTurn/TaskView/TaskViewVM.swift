//
//  TaskVM.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import UIKit

class TaskViewVM {
    // Static Values
    let taskHistoryTitleLabelText: NSAttributedString = NSAttributedString(string: "Task History",
                                                                attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    let taskInformationButtonString: String = "See More"
    let taskCompleteButtonString: String = "Mark Task Complete"
    
    // Dynamic Values
    let contentTitle: String
    let assignedUserString: String
    let assignedTeamString: String
    let taskEntries: [TaskEntryModel]
    
    init(task: TaskModel) {
        self.contentTitle = task.taskName
        self.assignedUserString = task.findCurrentTaskEntry()?.assignedUser.username ?? ""
        // TODO: - Need to attach team object to getTask
        self.assignedTeamString = task.teamId
        self.taskEntries = task.taskEntries?.filter({ taskEntry in
            taskEntry.status == .completed
        }) ?? []
        
    }
    
    
}
