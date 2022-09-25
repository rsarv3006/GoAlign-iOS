//
//  TaskHistoryModel.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

class TaskHistoryItem: Codable {
    let taskHistoryId: String
    let createdAt: Date
    let taskId: String
    let teamId: String
    let assignedUserId: String
    let dateCompleted: Date
    let notes: String?
    let pictureUrl: String?
}
