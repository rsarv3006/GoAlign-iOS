//
//  User.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

class UserService {
    static func deleteCurrentUser() async throws -> Bool {
        let url = try Networking.createUrl(endPoint: "v1/user")

        let (_, response) = try await Networking.delete(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return true
        }

        return false
    }

    static func isUserTeamManager(forTeam team: TeamModel) async throws -> Bool {
        if let user = AppState.getInstance().currentUser, user.userId == team.teamManagerId {
            return true
        }

        return false
    }

    static func isUserTeamManager(forTeamById teamId: UUID) async throws -> Bool {
        let teams = try await TeamService.getTeamsByTeamIds(teamIds: [teamId])
        let team = teams[0]
        if let user = AppState.getInstance().currentUser, user.userId == team.teamManagerId {
            return true
        }

        return false
    }
}
