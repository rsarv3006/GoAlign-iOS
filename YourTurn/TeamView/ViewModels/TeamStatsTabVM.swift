//
//  TeamStatsTabVM.swift
//  YourTurn
//
//  Created by rjs on 11/27/22.
//

import Foundation
import Combine

typealias TeamStatsModelResult = Result<Bool, Error>

class TeamStatsTabVM {
    var reloadStats = CurrentValueSubject<TeamStatsModelResult, Never>(.success(true))
    
    let tabTitleString = "Team Stats"
    
    var labelStrings: TeamStatsLabelDefaultStrings = TeamStatsLabelDefaultStrings()
    
    init(teamId: String) {
        getTeamStats(teamId: teamId)
    }
    
    private func getTeamStats(teamId: String) {
        Task {
            do {
                let teamStats = try await StatsService.getTeamStats(teamId: teamId)
                self.configureLabelStrings(teamStats: teamStats)
                self.reloadStats.send(.success(true))
            } catch {
                self.reloadStats.send(.failure(error))
            }
        }
    }
    
    private func configureLabelStrings(teamStats: TeamStatsModel) {
        labelStrings.totalNumberOfTasks += String(teamStats.totalNumberOfTasks)
        labelStrings.numberOfCompletedTaskEntries += String(teamStats.numberOfCompletedTaskEntries)
        labelStrings.numberOfCompletedTasks += String(teamStats.numberOfCompletedTasks)
        labelStrings.averageTasksPerUser += String(teamStats.averageTasksPerUser)
        labelStrings.numberOfTaskEntries += String(teamStats.numberOfTaskEntries)
    }
}

struct TeamStatsLabelDefaultStrings {
    var totalNumberOfTasks = "Tasks: "
    var numberOfCompletedTaskEntries = "Completed Task Entries: "
    var numberOfCompletedTasks = "Completed Tasks: "
    var averageTasksPerUser = "Average Tasks Per User: "
    var numberOfTaskEntries = "Task Entries: "
}
