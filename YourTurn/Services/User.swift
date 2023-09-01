//
//  User.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation
import JWTDecode

class UserService {
    func deleteCurrentUser() async throws -> Bool {
        let url = try Networking.createUrl(endPoint: "user")
        
        let (_, response) = try await Networking.delete(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return true
        }
        
        return false
    }
    
    func isUserTeamManager(forTeam team: TeamModel) async throws -> Bool {
        if let user = currentUser, user.userId == team.teamManagerId {
            return true
        }
        
        return false
    }
    
    func isUserTeamManager(forTeamById teamId: String) async throws -> Bool {
        let teams = try await TeamService.getTeamsByTeamIds(teamIds: [teamId])
        let team = teams[0]
        if let user = currentUser, user.userId == team.teamManagerId {
            return true
        }
        
        return false
    }
    
    var currentUser: UserModel?
    
    private init() {
        Task {
            do {
                try await self.updateUserFromStoredToken()
            } catch {
                print(error.localizedDescription)
                // TODO: Log error to server
            }
        }
    }
    
    func updateUserFromStoredToken() async throws {
        let accessToken = try await TokenService.shared.getAccessToken()
        try self.updateUserFromToken(accessToken: accessToken)
    }
    
    func updateUserFromToken(accessToken: String) throws {
        let jwt = try decode(jwt: accessToken)
        let body = jwt.body
       
        guard let jwtUserDict = body["User"] as? [String: Any] else {
            throw ServiceErrors.custom(message: "User is not a dictionary")
        }
       
        let userId = jwtUserDict["user_id"] as? String
        let username = jwtUserDict["username"] as? String
        let email = jwtUserDict["email"] as? String
        let isActive = jwtUserDict["is_active"] as? Bool
        let isEmailVerified = jwtUserDict["is_email_verified"] as? Bool
        let createdAtString = jwtUserDict["created_at"] as? String
        
        guard let createdAtString else {
            throw ServiceErrors.custom(message: "created_at is not a string")
        }
        
        let createAtDate = try decodeISO8601DateFromString(dateString: createdAtString)
       
        if let userId, let username, let email, let isActive, let isEmailVerified {
            currentUser = UserModel(userId: userId, createdAt: createAtDate, username: username, email: email, isActive: isActive, isEmailVerified: isEmailVerified)
        } else {
            currentUser = nil
            throw ServiceErrors.custom(message: "user is unparseable")
        }
    }
   
    func resetStoredUser() {
        currentUser = nil
    }
    
}

extension UserService {
    static let shared = UserService()
}
