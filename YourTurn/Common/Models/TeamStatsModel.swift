//
//  TeamStatsModel.swift
//  YourTurn
//
//  Created by rjs on 12/1/22.
//

import Foundation

struct TeamStatsModel: Codable {
    let totalNumberOfTasks: Int
    let numberOfCompletedTaskEntries: Int
    let numberOfCompletedTasks: Int
    let averageTasksPerUser: Double
    let numberOfTaskEntries: Int
}
