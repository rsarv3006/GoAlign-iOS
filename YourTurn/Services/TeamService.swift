//
//  TeamService.swift
//  YourTurn
//
//  Created by rjs on 7/30/22.
//

import Foundation

struct TeamService {
    static func getTeamsByCurrentUser() async throws -> [TeamModel] {
        let url = try Networking.createUrl(endPoint: "team/byCurrentUser")
        
        let (data, response) = try await Networking.get(url: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teams = try decoder.decode([TeamModel].self, from: data)
            return teams
        } else {
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func createTeam(teamDto: CreateTeamDto) async throws -> TeamModel {
        let url = try Networking.createUrl(endPoint: "team")
        
        let teamData = try JSONEncoder().encode(teamDto)

        let (data, response) = try await Networking.post(url: url, body: teamData)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let teamModel = try decoder.decode(TeamModel.self, from: data)
            return teamModel
        } else {
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
    
    static func getTeamsByTeamIds(teamIds: [String]) async throws -> [TeamModel] {
        let queryString = Networking.helpers.createQueryString(items: teamIds)
        let url = try Networking.createUrl(endPoint: "team?teamIds=\(queryString)")
        
        let (data, response) = try await Networking.get(url: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teams = try decoder.decode([TeamModel].self, from: data)
            return teams
        } else {
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func deleteTeam(teamId: String) async throws {
        let url = try Networking.createUrl(endPoint: "team/\(teamId)")
        
        let (data, response) = try await Networking.delete(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
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
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func updateTeamManager(teamId: String, newManagerId: String) async throws {
        let url = try Networking.createUrl(endPoint: "/team/updateTeamManager")
        
        let updateTeamManagerDto = UpdateTeamManagerDto(teamId: teamId, newManagerId: newManagerId)
        let updateTeamManagerData = try JSONEncoder().encode(updateTeamManagerDto)
        
        let (data, response) = try await Networking.put(url: url, body: updateTeamManagerData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
}
