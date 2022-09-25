//
//  TeamService.swift
//  YourTurn
//
//  Created by rjs on 7/30/22.
//

import Foundation

enum TeamError: Error {
    case custom(message: String)
}

struct TeamService {
    static func getTeamsbyCurrentUser(completionHandler: @escaping(([TeamModel]?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "team/byCurrentUser") else {
            completionHandler(nil, TeamError.custom(message: "Bad URL"))
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
                    
                    let teams = try decoder.decode([TeamModel].self, from: data)
                    completionHandler(teams, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, message: "Error pulling teams by current user: \(error)")
                    completionHandler(nil, error)
                    return
                }
            }
        }
    }
    
    static func createTeam(teamData: CreateTeamDto, completionHandler: @escaping(((TeamModel?, Error?) -> Void))) {
        guard let url = Networking.createUrl(endPoint: "team") else {
            completionHandler(nil, TeamError.custom(message: "Bad URL"))
            return
        }
        
        let teamData = try? JSONEncoder().encode(teamData)

        guard let teamData = teamData else {
            completionHandler(nil, TeamError.custom(message: "Serialization of Create Team DTO failed"))
            return
        }
        
        Networking.post(url: url, body: teamData) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 500 {
                        throw TeamError.custom(message: (String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong"))
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let teamModel = try decoder.decode(TeamModel.self, from: data)
                    completionHandler(teamModel, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, message: "FAILED to create team: \(error)")
                    completionHandler(nil, error)
                }
            }
        }
        
    }
}
