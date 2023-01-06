//
//  TeamTasksTabVM.swift
//  YourTurn
//
//  Created by rjs on 11/6/22.
//

import Foundation
import Combine

class TeamTasksTabVM {
    var screenTitle = "Team Tasks"
    
    var requestHomeReload = PassthroughSubject<Bool, Never>()

    var delegate: TeamTasksTabVMDelegate?
    
    private(set) var team: TeamModel
    var tasks: [TaskModel] {
        get {
            team.tasks
        }
    }
    
    init(team: TeamModel) {
        self.team = team
    }
    
    func refreshTeam() {
        Task {
            do {
                let teams = try await TeamService.getTeamsByTeamIds(teamIds: [team.teamId])
                self.team = teams[0]
                delegate?.requestTableReload()
            } catch {
                delegate?.showMessage(withTitle: "Uh OH", message: error.localizedDescription)
            }
        }
    }
}
