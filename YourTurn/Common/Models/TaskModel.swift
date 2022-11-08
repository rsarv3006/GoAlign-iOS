//
//  TaskModel.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

// TODO: CONVERT DATES TO ISO BEFORE SENDING TO THE SERVER

import Foundation

typealias TaskModelArray = [TaskModel]

enum TaskModelError: Error {
    case custom(message: String)
}

enum TaskStatusVariant: String, Codable {
  case active = "active"
  case completed = "completed"
  case overdue = "overdue"
}

class TaskModel: Codable {
    let taskId: String
    let createdAt: Date
    let taskName: String
    let notes: String?
    let startDate: Date
    let endDate: Date?
    let requiredCompletionsNeeded: Int?
    let completionCount: Int
    let intervalBetweenWindows: IntervalObject
    let windowLength: IntervalObject
    let teamId: String
    let creator: UserModel
    let status: TaskStatusVariant
    let taskEntries: [TaskEntryModel]?
    
    func findCurrentTaskEntry() -> TaskEntryModel? {
        var returnValue: TaskEntryModel? = nil
        if let taskEntries = taskEntries {
            returnValue = taskEntries.first { taskEntry in
                taskEntry.status == TaskEntryStatus.active
            }
        }
        return returnValue
    }
    
    func checkIfCurrentUserIsAssignedUser(completionHandler: @escaping ((Bool) -> Void)) {
        UserService.getCurrentUser { user, error in
            let currentTask = self.findCurrentTaskEntry()
            if let user = user, user.userId == currentTask?.assignedUser.userId {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
}

class CreateTaskDto: Codable {
    let taskName: String
    let notes: String?
    let startDate: Date
    let endDate: Date?
    let requiredCompletionsNeeded: Int?
    let intervalBetweenWindows: IntervalObject
    let windowLength: IntervalObject
    let teamId: String
    let assignedUserId: String
    let creatorUserId: String
    
    
    init(from formDict: [String: Any], uid: String?) throws {
        if let taskName = formDict[CreateTaskDictKeys.TASK_NAME] as? String {
            self.taskName = taskName
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Task Name")
        }
        
        if let notes = formDict[CreateTaskDictKeys.NOTES] as? String {
            self.notes = notes
        } else {
            self.notes = nil
        }
        
        if let startDate = formDict[CreateTaskDictKeys.START_DATE] as? Date {
            self.startDate = startDate
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Start Date")
        }
        
        if let endDate = formDict[CreateTaskDictKeys.END_DATE] as? Date {
            self.endDate = endDate
        } else {
            self.endDate = nil
        }
        
        if let requiredCompletionsNeededString = formDict[CreateTaskDictKeys.REQUIRED_COMPLETIONS_NEEDED] as? String, let requiredCompletionsNeeded = Int(requiredCompletionsNeededString) {
            self.requiredCompletionsNeeded = requiredCompletionsNeeded
        } else {
            self.requiredCompletionsNeeded = nil
        }
        
        if let intervalBetweenWindows = formDict[CreateTaskDictKeys.INTERVAL_BETWEEN_WINDOWS] as? IntervalObject {
            self.intervalBetweenWindows = intervalBetweenWindows
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Interval Between Windows")
        }
        
        if let windowLength = formDict[CreateTaskDictKeys.WINDOW_LENGTH] as? IntervalObject {
            self.windowLength = windowLength
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Window Length")
        }
        
        if let teamSelectValues = formDict[FormField.taskTeamPicker.rawValue] as? TeamSelectModalReturnModel {
            self.teamId = teamSelectValues.team.teamId
            self.assignedUserId = teamSelectValues.teamMember.userId
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Team and Member")
        }
        

        
        if let uid = uid {
            self.creatorUserId = uid
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Creator User id")
        }
    }
    
    func toString() -> String {
        return "taskName: \(taskName) - notes: \(String(describing: notes)) - startDate: \(startDate) - endDate: \(String(describing: endDate))"
    }
}

struct CreateTaskDictKeys {
    static let TASK_NAME = "taskName"
    static let NOTES = "notes"
    static let START_DATE = "startDate"
    static let END_DATE = "endDate"
    static let REQUIRED_COMPLETIONS_NEEDED = "requiredCompletionsNeeded"
    static let INTERVAL_BETWEEN_WINDOWS = "intervalBetweenWindows"
    static let WINDOW_LENGTH = "windowLength"
    static let TEAM_ID = "teamId"
    static let CREATOR_USER_ID = "creatorUserId"
    static let ASSIGNED_USER_ID = "assignedUserId"
    
}
