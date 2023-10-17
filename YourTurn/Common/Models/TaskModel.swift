//
//  TaskModel.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

typealias TaskModelArray = [TaskModel]

enum TaskModelError: Error, LocalizedError {
    case custom(message: String)

    public var errorDescription: String? {
        switch self {
        case .custom(let message):
            return NSLocalizedString(message, comment: "An unexpected error occurred.")
        }
    }
}

enum TaskStatusVariant: String, Codable {
    case active
    case completed
    case overdue
}

struct TaskReturnModel: Codable {
    let task: TaskModel
}
class TaskModel: Codable {
    let taskId: UUID
    let createdAt: Date
    let taskName: String
    let notes: String?
    let startDate: Date
    let endDate: Date?
    let requiredCompletionsNeeded: Int?
    let completionCount: Int
    let intervalBetweenWindows: IntervalObject
    let windowDuration: IntervalObject
    let teamId: UUID
    let creator: UserModel
    let status: String
    let taskEntries: [TaskEntryModel]?

    func findCurrentTaskEntry() -> TaskEntryModel? {
        var returnValue: TaskEntryModel?
        if let taskEntries = taskEntries {
            returnValue = taskEntries.first { taskEntry in
                taskEntry.status == TaskEntryStatus.active.rawValue
            }
        }
        return returnValue
    }

    func checkIfCurrentUserIsAssignedUser(completionHandler: @escaping ((Bool) -> Void)) {
        Task {
            guard let user = AppState.getInstance().currentUser else {
                completionHandler(false)
                return
            }

            let currentTask = self.findCurrentTaskEntry()
            if user.userId == currentTask?.assignedUser.userId {
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
    let windowDuration: IntervalObject
    let teamId: UUID
    let assignedUserId: UUID
    let creatorUserId: UUID

    init(from formDict: [String: Any], uid: UUID?) throws {
        if let taskName = formDict[CreateTaskDictKeys.TASKNAME] as? String {
            self.taskName = taskName
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Task Name")
        }

        if let notes = formDict[CreateTaskDictKeys.NOTES] as? String {
            self.notes = notes
        } else {
            self.notes = nil
        }

        if let startDate = formDict[CreateTaskDictKeys.STARTDATE] as? Date {
            self.startDate = startDate
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Start Date")
        }

        if let endDate = formDict[CreateTaskDictKeys.ENDDATE] as? Date {
            self.endDate = endDate
        } else {
            self.endDate = nil
        }

        if let requiredCompletionsNeededString = formDict[CreateTaskDictKeys.REQUIREDCOMPLETIONSNEEDED] as? String,
            let requiredCompletionsNeeded = Int(requiredCompletionsNeededString) {
            self.requiredCompletionsNeeded = requiredCompletionsNeeded
        } else {
            self.requiredCompletionsNeeded = nil
        }

        if let intervalBetweenWindows = formDict[CreateTaskDictKeys.INTERVALBETWEENWINDOWS] as? IntervalObject {
            self.intervalBetweenWindows = intervalBetweenWindows
        } else {
            throw TaskModelError.custom(message: "Create TaskModel: invalid value given for Interval Between Windows")
        }

        if let windowLength = formDict[CreateTaskDictKeys.WINDOWLENGTH] as? IntervalObject {
            self.windowDuration = windowLength
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
        // swiftlint:disable:next line_length
        return "taskName: \(taskName) - notes: \(String(describing: notes)) - startDate: \(startDate) - endDate: \(String(describing: endDate))"
    }
}

struct CreateTaskDictKeys {
    static let TASKNAME = "taskName"
    static let NOTES = "notes"
    static let STARTDATE = "startDate"
    static let ENDDATE = "endDate"
    static let REQUIREDCOMPLETIONSNEEDED = "requiredCompletionsNeeded"
    static let INTERVALBETWEENWINDOWS = "intervalBetweenWindows"
    static let WINDOWLENGTH = "windowLength"
    static let TEAMID = "teamId"
    static let CREATORUSERID = "creatorUserId"
    static let ASSIGNEDUSERID = "assignedUserId"

}

class UpdateTaskDto: Codable {
    private(set) var taskId: UUID?
    let taskName: String?
    let notes: String?
    let startDate: Date?
    let endDate: Date?
    let requiredCompletionsNeeded: Int?
    let intervalBetweenWindows: IntervalObject?
    let windowLength: IntervalObject?
    let assignedUserId: UUID?

    init(
        from formDict: [String: Any],
        uid: UUID?,
        taskToUpdate: TaskModel,
        assignedUser currentAssignedUser: UUID? = nil) throws {
        if let taskName = formDict[CreateTaskDictKeys.TASKNAME] as? String, taskName != taskToUpdate.taskName {
            self.taskName = taskName
        } else {
            self.taskName = nil
        }

        if let notes = formDict[CreateTaskDictKeys.NOTES] as? String, notes != taskToUpdate.notes {
            self.notes = notes
        } else {
            self.notes = nil
        }

        if let startDate = formDict[CreateTaskDictKeys.STARTDATE] as? Date, startDate != taskToUpdate.startDate {
            self.startDate = startDate
        } else {
            self.startDate = nil
        }

        if let endDate = formDict[CreateTaskDictKeys.ENDDATE] as? Date, endDate != taskToUpdate.endDate {
            self.endDate = endDate
        } else {
            self.endDate = nil
        }

        if let requiredCompletionsNeededString = formDict[CreateTaskDictKeys.REQUIREDCOMPLETIONSNEEDED] as? String,
            let requiredCompletionsNeeded = Int(requiredCompletionsNeededString),
           requiredCompletionsNeeded != taskToUpdate.requiredCompletionsNeeded {
            self.requiredCompletionsNeeded = requiredCompletionsNeeded
        } else {
            self.requiredCompletionsNeeded = nil
        }

        if let intervalBetweenWindows = formDict[CreateTaskDictKeys.INTERVALBETWEENWINDOWS] as? IntervalObject,
            intervalBetweenWindows != taskToUpdate.intervalBetweenWindows {
            self.intervalBetweenWindows = intervalBetweenWindows
        } else {
            self.intervalBetweenWindows = nil
        }

        if let windowLength = formDict[CreateTaskDictKeys.WINDOWLENGTH] as? IntervalObject,
            windowLength != taskToUpdate.windowDuration {
            self.windowLength = windowLength
        } else {
            self.windowLength = nil
        }

        if let assignedUserId = formDict[CreateTaskDictKeys.ASSIGNEDUSERID] as? UUID,
            assignedUserId != currentAssignedUser {
            self.assignedUserId = assignedUserId
        } else {
            self.assignedUserId = nil
        }
    }

    func insertTaskId(taskId: UUID) {
        self.taskId = taskId
    }

    func toString() -> String {
        // swiftlint:disable:next line_length
        return "taskName: \(String(describing: taskName)) - notes: \(String(describing: notes)) - startDate: \(String(describing: startDate)) - endDate: \(String(describing: endDate))"
    }
}

struct TasksReturnModel: Codable {
    let tasks: [TaskModel]
    let message: String
}

struct TaskCreateReturnModel: Codable {
    let task: TaskModel
    let message: String
}
