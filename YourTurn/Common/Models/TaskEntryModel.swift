//
//  TaskEntryModel.swift
//  YourTurn
//
//  Created by Robby on 10/7/22.
//

import Foundation

enum TaskEntryStatus: String, Codable {
  case active = "active"
  case completed = "completed"
  case overdue = "overdue"
}

struct TaskEntryModel: Codable {
    let taskEntryId: UUID
    let startDate: Date
    let endDate: Date?
    let notes: String
    let status: String
    let completedDate: Date?
    let assignedUser: UserModel
    let taskId: UUID
}
