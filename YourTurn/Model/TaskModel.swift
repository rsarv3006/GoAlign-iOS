//
//  TaskModel.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

typealias TaskModelArray = [TaskModel]

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
