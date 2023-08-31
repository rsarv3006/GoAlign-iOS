//
//  User.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation
import JWTDecode

struct UserService {
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
    
    let currentUser: UserModel?
    
    static let shared = UserService()
}

extension UserService {
    private init() {
        do {
            let jwt = try decode(jwt: KeychainService.getAccessToken())
            let body = jwt.body
            
            let userId = body["user_id"] as? String
            let username = body["username"] as? String
            let email = body["email"] as? String
            let isActive = body["is_active"] as? Bool
            let isEmailVerified = body["is_email_verified"] as? Bool
            let createdAt = body["created_at"] as? Date
            
            self.currentUser = UserModel(userId: userId!, createdAt: createdAt!, username: username!, email: email!, isActive: isActive!, isEmailVerified: isEmailVerified!)
        } catch {
            print(error.localizedDescription)
            // TODO: Log error to server
            self.currentUser = nil
        }
    }
    
}
