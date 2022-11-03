//
//  TeamInvite.swift
//  YourTurn
//
//  Created by rjs on 8/28/22.
//

import Foundation

enum TeamInviteError: Error {
    case custom(message: String)
}

enum TeamInviteStatus {
    case success
    case failure
}

struct TeamInviteService {
    static func getTeamInvitesByCurrentUser(completionHandler: @escaping(([TeamInviteModel]?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "teamInvite/byCurrentUser") else {
            completionHandler(nil, TeamInviteError.custom(message: "Bad URL"))
            return
        }
        
        Networking.get(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let teamInvites = try decoder.decode([TeamInviteModel].self, from: data)
                    completionHandler(teamInvites, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, name: Logger.Events.Team.Invite.fetchFailed, payload: ["error": error])
                    completionHandler(nil, error)
                    return
                }
            }
        }
    }
    
    static func acceptInvite(inviteId: String, completionHandler: @escaping((TeamInviteStatus, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "teamInvite/\(inviteId)/accept") else {
            completionHandler(.failure, TeamInviteError.custom(message: "Bad URL"))
            return
        }
        
        Networking.post(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(.failure, error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completionHandler(.success, nil)
                } else {
                    completionHandler(.failure, TeamInviteError.custom(message: "Unknown Error Accepting Invite"))
                }
            }
        }
        
        
    }
    
    static func declineInvite(inviteId: String, completionHandler: @escaping((TeamInviteStatus, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "teamInvite/\(inviteId)/decline") else {
            completionHandler(.failure, TeamInviteError.custom(message: "Bad URL"))
            return
        }
        
        Networking.post(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(.failure, error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completionHandler(.success, nil)
                } else {
                    completionHandler(.failure, TeamInviteError.custom(message: "Unknown Error declining Invite"))
                }
            }
        }
    }
    
    static func createInvite(createInviteDto: CreateInviteDtoModel, completionHandler: @escaping((TeamInviteStatus, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "teamInvite") else {
            completionHandler(.failure, TeamInviteError.custom(message: "Bad URL"))
            return
        }
        
        let createInviteData = try? JSONEncoder().encode(createInviteDto)

        guard let createInviteData = createInviteData else {
            completionHandler(.failure, TeamInviteError.custom(message: "Serialization of Create Invite DTO failed"))
            return
        }
        
        Networking.post(url: url, body: createInviteData) { data, response, error in
            guard error == nil else {
                completionHandler(.failure, error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 201 {
                    completionHandler(.success, nil)
                } else {
                    completionHandler(.failure, TeamInviteError.custom(message: "Unknown Error declining Invite"))
                }
            }
        }
    }
}
