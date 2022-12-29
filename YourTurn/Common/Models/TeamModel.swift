//
//  TeamModel.swift
//  YourTurn
//
//  Created by rjs on 7/30/22.
//

import Foundation

class TeamModel: Codable {
    let teamId: String
    let createdAt: Date
    let teamName: String
    let tasks: TaskModelArray
    let teamMembers: [UserModel]
    let teamManagerId: String
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
    let canAllTeamMembersAddTasks: Bool
}

class UpdateCanAllTeamMembersAddTasksSettingDto: Codable {
    let newSettingValue: Bool
    
    init(newSettingValue: Bool) {
        self.newSettingValue = newSettingValue
    }
}
