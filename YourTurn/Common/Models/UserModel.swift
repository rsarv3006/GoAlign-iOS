//
//  UserModel.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

class UserModel: Codable {
    let userId: UUID
    let createdAt: Date
    let username: String
    let email: String
    let isActive: Bool
    let isEmailVerified: Bool
    
    init(userId: UUID, createdAt: Date, username: String, email: String, isActive: Bool, isEmailVerified: Bool) {
        self.userId = userId
        self.createdAt = createdAt
        self.username = username
        self.email = email
        self.isActive = isActive
        self.isEmailVerified = isEmailVerified
    }
    
    func toString() {
        print("userId: \(userId), createdAt: \(createdAt), username: \(username), email: \(email), isActive: \(isActive), isEmailVerified: \(isEmailVerified)")
    }
}

class CreateUserDto: Codable {
    let username: String
    let email: String
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
    
    func toDict() -> [String : String] {
        var dict = [String: String]()
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
