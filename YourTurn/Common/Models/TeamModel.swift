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
