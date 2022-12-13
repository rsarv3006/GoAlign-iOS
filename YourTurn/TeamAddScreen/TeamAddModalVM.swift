//
//  TeamAddModalVM.swift
//  YourTurn
//
//  Created by rjs on 8/23/22.
//

import Foundation

struct TeamAddModalVM {
    let closeButtonTitleText = "Create Team"
    let createTeamAndInviteButtonText = "Create Team & Invite Users"
    let modalTitleText = "Create a Team"
    let teamNameFieldPlacholderText = "Team Name"
    
    
    func createTeam(name: String, completion: @escaping(((TeamModel?, Error?) -> Void))) {
        let teamDto = CreateTeamDto(teamName: name)
        TeamService.createTeam(teamData: teamDto, completionHandler: completion)
    }
    
    func createTeamCreateFailErrorMessageString(error: Error) -> String {
        return "Problem encountered creating the team. \(error.localizedDescription)"
    }
}
