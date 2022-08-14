//
//  TaskModel.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

typealias TaskModelArray = [TaskModel]

enum TaskModelError: Error {
    case custom(message: String)
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
    let intervalBetweenWindows: IntervalObject?
    let windowLength: IntervalObject?
    let teamId: String
    let assignedUser: UserModel?
    let creator: UserModel
    let status: String
    let taskHistoryItems: TaskHistoryItem?
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
        
        if let teamId = formDict[CreateTaskDictKeys.TEAM_ID] as? String {
            self.teamId = teamId
        }  else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Team Id")
        }
        
        if let assignedUserId = formDict[CreateTaskDictKeys.ASSIGNED_USER_ID] as? String {
            self.assignedUserId = assignedUserId
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Assigned User Id")
        }
        
        if let uid = uid {
            self.creatorUserId = uid
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Creator User id")
        }
        
        
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
// ["numberofRequiredCompletions": Optional("56"), "taskName": Optional("Asdffff"), "windowLength": Optional(YourTurn.IntervalObject), "notes": nil, "endDate": Optional(Optional(2022-08-26 20:03:00 +0000)), "intervalBetweenWindows": Optional(YourTurn.IntervalObject), "startDate": Optional(2022-08-18 20:03:00 +0000)]
