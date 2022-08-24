//
//  TeamAddModalVM.swift
//  YourTurn
//
//  Created by rjs on 8/23/22.
//

import Foundation

struct TeamAddModalVM {
    let closeButtonTitleText = "Create"
    let modalTitleText = "Create a Team"
    let teamNameFieldPlacholderText = "Team Name"
    
    func createTeam(name: String, completion: @escaping(((TeamModel?, Error?) -> Void))) {
        let teamDto = CreateTeamDto(teamName: name)
        TeamService.createTeam(teamData: teamDto, completionHandler: completion)
    }
}
