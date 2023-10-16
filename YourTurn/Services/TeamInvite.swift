//
//  TeamInvite.swift
//  YourTurn
//
//  Created by rjs on 8/28/22.
//

import Foundation

enum TeamInviteStatus {
    case success
    case failure
}

struct TeamInviteService {
    static func getTeamInvitesByCurrentUser() async throws -> [TeamInviteModel] {
        let url = try Networking.createUrl(endPoint: "v1/team-invite")

        let (data, response) = try await Networking.get(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamInvitesResponse = try globalDecoder.decode(TeamInviteGetByCurrentUserReturnModel.self, from: data)
            return teamInvitesResponse.invites
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func acceptInvite(inviteId: UUID) async throws -> TeamInviteStatus {
        let url = try Networking.createUrl(endPoint: "v1/team-invite/\(inviteId.uuidString)/accept")

        let (data, response) = try await Networking.post(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            return .success
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func declineInvite(inviteId: UUID) async throws -> TeamInviteStatus {
        let url = try Networking.createUrl(endPoint: "v1/team-invite/\(inviteId)/decline")

        let (data, response) = try await Networking.post(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return .success
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func createInvite(createInviteDto: CreateInviteDtoModel) async throws -> TeamInviteStatus {
        let url = try Networking.createUrl(endPoint: "v1/team-invite")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let createInviteData = try encoder.encode(createInviteDto)

        let (data, response) = try await Networking.post(url: url, body: createInviteData)

        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            return .success
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func getOutstandingInvitesByTeamId(teamId: UUID) async throws -> [TeamInviteModel] {
        let url = try Networking.createUrl(endPoint: "v1/team-invite/byTeam/\(teamId.uuidString)")

        let (data, response) = try await Networking.get(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamInvitesReturn = try globalDecoder.decode(TeamInvitesGetByTeamIdReturnModel.self, from: data)
            return teamInvitesReturn.teamInvites
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func deleteTeamInvite(inviteId: UUID) async throws {
        let url = try Networking.createUrl(endPoint: "v1/team-invite/\(inviteId)")

        let (data, response) = try await Networking.delete(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }

    }
}
