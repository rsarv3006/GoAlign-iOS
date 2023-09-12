//
//  TeamModel.swift
//  YourTurn
//
//  Created by rjs on 7/30/22.
//

import Foundation

class TeamModel: Codable {
    let teamId: UUID
    let createdAt: Date
    let teamName: String
    let tasks: TaskModelArray
    let users: [UserModel]
    let teamManagerId: UUID
}

class CreateTeamDto: Codable {
    let teamName: String
    
    init(teamName: String) {
        self.teamName = teamName
    }
}

class UpdateTeamManagerDto: Codable {
    let teamId: String
    let newManagerId: String
    
    init(teamId: String, newManagerId: String) {
        self.teamId = teamId
        self.newManagerId = newManagerId
    }
}

class TeamSettingsModel: Codable {
    let teamSettingsId: String
    let teamId: String
    let canAllMembersAddTasks: Bool
}

class TeamSettingsReturnModel: Codable {
    let settings: TeamSettingsModel
}

class UpdateTeamSettings: Codable {
    let canAllMembersAddTasks: Bool?
    
    init (canAllMembersAddTasks: Bool?) {
        self.canAllMembersAddTasks = canAllMembersAddTasks
    }
}

class TeamsGetByCurrentUserReturnModel: Codable {
    let teams: [TeamModel]
    let message: String
}

class TeamsCreateReturnModel: Codable {
    let team: TeamModel
    let message: String
}

