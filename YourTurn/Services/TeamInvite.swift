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
        let url = try Networking.createUrl(endPoint: "teamInvite")
        
        let (data, response) = try await Networking.get(url: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamInvites = try decoder.decode([TeamInviteModel].self, from: data)
            return teamInvites
        } else {
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func acceptInvite(inviteId: String) async throws -> TeamInviteStatus {
        let url = try Networking.createUrl(endPoint: "teamInvite/\(inviteId)/accept")
        
        let (data, response) = try await Networking.post(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            return .success
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func declineInvite(inviteId: String) async throws -> TeamInviteStatus {
        let url = try Networking.createUrl(endPoint: "teamInvite/\(inviteId)/decline")
        
        let (data, response) = try await Networking.post(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            return .success
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func createInvite(createInviteDto: CreateInviteDtoModel) async throws -> TeamInviteStatus {
        let url = try Networking.createUrl(endPoint: "teamInvite")
        
        let createInviteData = try JSONEncoder().encode(createInviteDto)
        
        let (data, response) = try await Networking.post(url: url, body: createInviteData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            return .success
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func getOutstandingInvitesByTeamId(teamId: String) async throws -> [TeamInviteModel] {
        let url = try Networking.createUrl(endPoint: "teamInvite/outstandingTeamInvites/\(teamId)")
        
        let (data, response) = try await Networking.get(url: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamInvites = try decoder.decode([TeamInviteModel].self, from: data)
            return teamInvites
        } else {
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func deleteTeamInvite(inviteId: String) async throws {
        let url = try Networking.createUrl(endPoint: "teamInvite/\(inviteId)")
        
        let (data, response) = try await Networking.delete(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }

    }
}
