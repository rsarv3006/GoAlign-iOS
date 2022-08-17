//
//  TeamModel.swift
//  YourTurn
//
//  Created by rjs on 7/30/22.
//

import Foundation

class TeamModel: Codable {
    let teamId: String
    let createdAt: String
    let teamName: String
    let tasks: TaskModelArray
    let teamMembers: [UserModel]
}
