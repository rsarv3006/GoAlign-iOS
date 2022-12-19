//
//  UserModel.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

class UserModel: Codable {
      let userId: String
      let createdAt: Date
      let username: String
      let email: String
      let isActive: Bool
}

class CreateUserDto: Codable {
    let userId: String
    let username: String
    let email: String
    
    init(userId: String, username: String, email: String) {
        self.userId = userId
        self.username = username
        self.email = email
    }
    
    func toDict() -> [String : String] {
        var dict = [String: String]()
        dict["userId"] = self.userId
        dict["username"] = self.username
        dict["email"] = self.email
        return dict
    }

}

class RemoveUserFromTeamDto: Codable {
    let userToRemove: String
    let teamId: String
    
    init(userToRemove: String, teamId: String) {
        self.userToRemove = userToRemove
        self.teamId = teamId
    }
}
