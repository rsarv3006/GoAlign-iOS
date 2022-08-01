//
//  HomeScreenTeamCellVM.swift
//  YourTurn
//
//  Created by rjs on 6/26/22.
//

import Foundation

struct HomeScreenTeamCellVM {
    let teamNameLabelString: String
    
    let numberOfTeamTasksLabelString: String
    
    init(withTeam team: TeamModel) {
        teamNameLabelString = team.teamName
        numberOfTeamTasksLabelString = "Tasks: \(team.tasks.count)"
    }
}
