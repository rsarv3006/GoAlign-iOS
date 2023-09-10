//
//  TeamService.swift
//  YourTurn
//
//  Created by rjs on 7/30/22.
//

import Foundation

struct TeamService {
    static func getTeamsByCurrentUser() async throws -> [TeamModel] {
        let url = try Networking.createUrl(endPoint: "team")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamsResponse = try GlobalDecoder.decode(TeamsGetByCurrentUserReturnModel.self, from: data)
            return teamsResponse.teams
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func createTeam(teamDto: CreateTeamDto) async throws -> TeamModel {
        let url = try Networking.createUrl(endPoint: "team")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let teamData = try encoder.encode(teamDto)

        let (data, response) = try await Networking.post(url: url, body: teamData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let teamCreateReturn = try GlobalDecoder.decode(TeamsCreateReturnModel.self, from: data)
            return teamCreateReturn.team
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func getTeamsByTeamIds(teamIds: [String]) async throws -> [TeamModel] {
        let queryString = Networking.Helpers.createQueryString(items: teamIds)
        let url = try Networking.createUrl(endPoint: "team?teamIds=\(queryString)")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamsReturn = try GlobalDecoder.decode(TeamsGetByCurrentUserReturnModel.self, from: data)
            return teamsReturn.teams
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func deleteTeam(teamId: String) async throws {
        let url = try Networking.createUrl(endPoint: "team/\(teamId)")
        
        let (data, response) = try await Networking.delete(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func removeUserFromTeam(teamId: String, userToRemove: String) async throws {
        let url = try Networking.createUrl(endPoint: "team/removeUserFromTeam")
        
        let removeUserDto = RemoveUserFromTeamDto(userToRemove: userToRemove, teamId: teamId)
        let removeUserData = try JSONEncoder().encode(removeUserDto)
        
        let (data, response) = try await Networking.post(url: url, body: removeUserData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func updateTeamManager(teamId: String, newManagerId: String) async throws {
        let url = try Networking.createUrl(endPoint: "team/updateTeamManager")
        
        let updateTeamManagerDto = UpdateTeamManagerDto(teamId: teamId, newManagerId: newManagerId)
        let updateTeamManagerData = try JSONEncoder().encode(updateTeamManagerDto)
        
        let (data, response) = try await Networking.put(url: url, body: updateTeamManagerData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func getTeamSettings(teamId: String) async throws -> TeamSettingsModel {
        let url = try Networking.createUrl(endPoint: "team/\(teamId)/settings")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teams = try GlobalDecoder.decode(TeamSettingsModel.self, from: data)
            return teams
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func updateCanAllTeamMembersAddTasksSetting(teamId: String, newSettingValue: Bool) async throws {
        let url = try Networking.createUrl(endPoint: "team/\(teamId)/settings/canAllTeamMembersAddTasks")
        
        let updateSettingDto = UpdateCanAllTeamMembersAddTasksSettingDto(newSettingValue: newSettingValue)
        let updateSettingData = try JSONEncoder().encode(updateSettingDto)
        
        let (data, response) = try await Networking.patch(url: url, body: updateSettingData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
}
