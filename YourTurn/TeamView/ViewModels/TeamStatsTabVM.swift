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
        StatsService.getTeamStats(teamId: teamId) { teamStats, error in
            if let error = error {
                self.reloadStats.send(.failure(error))
            } else if let teamStats = teamStats {
                self.configureLabelStrings(teamStats: teamStats)
                self.reloadStats.send(.success(true))
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
