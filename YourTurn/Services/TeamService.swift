//
//  TeamService.swift
//  YourTurn
//
//  Created by rjs on 7/30/22.
//

import Foundation

struct TeamService {
    static func getTeamsByCurrentUser() async throws -> [TeamModel] {
        let url = try Networking.createUrl(endPoint: "v1/team")

        let (data, response) = try await Networking.get(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamsResponse = try globalDecoder.decode(TeamsGetByCurrentUserReturnModel.self, from: data)
            return teamsResponse.teams
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }

    }

    static func createTeam(teamDto: CreateTeamDto) async throws -> TeamModel {
        let url = try Networking.createUrl(endPoint: "v1/team")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let teamData = try encoder.encode(teamDto)

        let (data, response) = try await Networking.post(url: url, body: teamData)

        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let teamCreateReturn = try globalDecoder.decode(TeamsCreateReturnModel.self, from: data)
            return teamCreateReturn.team
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }

    }

    static func getTeamsByTeamIds(teamIds: [UUID]) async throws -> [TeamModel] {
        let queryString = Networking.Helpers.createQueryString(items: teamIds.map({ uuid in
            return uuid.uuidString
        }))
        let url = try Networking.createUrl(endPoint: "v1/team?teamIds=\(queryString)")

        let (data, response) = try await Networking.get(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamsReturn = try globalDecoder.decode(TeamsGetByCurrentUserReturnModel.self, from: data)
            return teamsReturn.teams
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func deleteTeam(teamId: UUID) async throws {
        let url = try Networking.createUrl(endPoint: "v1/team/\(teamId.uuidString)")

        let (data, response) = try await Networking.delete(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }

    }

    static func removeUserFromTeam(teamId: UUID, userToRemove: UUID) async throws {
        let url = try Networking.createUrl(endPoint: "v1/team/\(teamId)/removeUserFromTeam/\(userToRemove)")

        let removeUserDto = RemoveUserFromTeamDto(userToRemove: userToRemove.uuidString, teamId: teamId.uuidString)
        let removeUserData = try JSONEncoder().encode(removeUserDto)

        let (data, response) = try await Networking.delete(url: url, body: removeUserData)

        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func updateTeamManager(teamId: UUID, newManagerId: UUID) async throws {
        let url = try Networking.createUrl(endPoint: "v1/team/updateTeamManager/\(teamId)/\(newManagerId)")

        let (data, response) = try await Networking.post(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            return
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func getTeamSettings(teamId: UUID) async throws -> TeamSettingsModel {
        let url = try Networking.createUrl(endPoint: "v1/team/\(teamId.uuidString)/settings")

        let (data, response) = try await Networking.get(url: url)

        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamSettingsReturn = try globalDecoder.decode(TeamSettingsReturnModel.self, from: data)
            return teamSettingsReturn.settings
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }

    static func updateTeamSettings(teamId: UUID, newSettingValue: Bool) async throws {
        let url = try Networking.createUrl(endPoint: "v1/team/\(teamId)/settings")

        let updateSettingDto = UpdateTeamSettings(canAllMembersAddTasks: newSettingValue)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let updateSettingData = try encoder.encode(updateSettingDto)

        let (data, response) = try await Networking.put(url: url, body: updateSettingData)

        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            return
        } else {
            let serverError = try globalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
}
