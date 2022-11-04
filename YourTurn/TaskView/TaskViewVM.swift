//
//  TaskVM.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import UIKit
import Combine

class TaskViewVM {
    var subscriptions = Set<AnyCancellable>()
    private(set) var teamNameSubject = PassthroughSubject<String, Never>()
    
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
    
    let task: TaskModel
    
    init(task: TaskModel) {
        self.contentTitle = task.taskName
        self.assignedUserString = task.findCurrentTaskEntry()?.assignedUser.username ?? ""
        // TODO: - Need to attach team object to getTask
        self.assignedTeamString = task.teamId
        self.taskEntries = task.taskEntries?.filter({ taskEntry in
            taskEntry.status == .completed
        }) ?? []
        
        self.task = task
        
        getTeamName(teamId: task.teamId)
    }
    
    func checkIfMarkTaskCompleteButtonShouldShow(completionHandler: @escaping((Bool) -> Void)) {
        task.checkIfCurrentUserIsAssignedUser(completionHandler: completionHandler)
    }
    
    func getTeamName(teamId: String) {
        TeamService.getTeamsByTeamIds(teamIds: [teamId]) { teams, error in
            if error == nil, let team = teams?[0] {
                self.teamNameSubject.send(team.teamName)
            }
        }
    }
}
