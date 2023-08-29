//
//  TaskSubViewVM.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/3/23.
//

import UIKit
import Combine

class TaskSubViewVM {
    
    var delegate: TaskSubViewVMDelegate?
    var subscriptions = Set<AnyCancellable>()
    private(set) var teamNameSubject = PassthroughSubject<Result<String, Error>, Never>()
    
    // Static Values
    let taskHistoryTitleLabelText: NSAttributedString = NSAttributedString(string: "Task History",
                                                                attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    let taskInformationButtonString: String = "See More"
    let taskCompleteButtonString: String = "Mark Task Complete"
    let taskIsCompleteLabelString: String = "Task has been Completed!"
    
    // Dynamic Values
    let contentTitle: String
    let assignedUserString: String
    let assignedTeamString: String
    let taskEntries: [TaskEntryModel]
    let isTaskCompleted: Bool
    
    let task: TaskModel
    
    init(task: TaskModel) {
        self.contentTitle = task.taskName
        self.assignedUserString = task.findCurrentTaskEntry()?.assignedUser.username ?? ""
        self.isTaskCompleted = task.status == TaskStatusVariant.completed ? true : false
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
    
    func onRequestMarkTaskComplete() {
        Task {
            do {
                let _ = try await TaskService.markTaskComplete(taskId: task.taskId)
                
                delegate?.requestPopView()
                delegate?.requestHomeReloadFromSubView()
            } catch {
                delegate?.requestShowMessage(withTitle: "Uh Oh", message: "Error Marking Task Complete: \(error.localizedDescription)")
            }
        }
    }
    
    func getTeamName(teamId: String) {
        Task {
            do {
                let teams = try await TeamService.getTeamsByTeamIds(teamIds: [teamId])
                self.teamNameSubject.send(.success(teams[0].teamName))
            } catch {
                self.teamNameSubject.send(.failure(error))
            }
        }
    }
}
