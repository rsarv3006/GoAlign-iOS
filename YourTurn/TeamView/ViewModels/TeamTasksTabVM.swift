//
//  TeamTasksTabVM.swift
//  YourTurn
//
//  Created by rjs on 11/6/22.
//

import Foundation
import Combine

class TeamTasksTabVM {
    
    var team: TeamModel
    var screenTitle = "Team Tasks"
    
    init(team: TeamModel) {
        self.team = team
    }
}
