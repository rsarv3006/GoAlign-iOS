//
//  TeamService.swift
//  YourTurn
//
//  Created by rjs on 7/30/22.
//

import Foundation

struct TeamService {
    static func getTeamsbyCurrentUser(completionHandler: @escaping(([TeamModel]?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "team/byCurrentUser") else {
            completionHandler(nil, ServiceErrors.unknownUrl)
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
                    completionHandler(nil, error)
                    return
                }
            }
        }
    }
    
    static func createTeam(teamData: CreateTeamDto, completionHandler: @escaping(((TeamModel?, Error?) -> Void))) {
        guard let url = Networking.createUrl(endPoint: "team") else {
            completionHandler(nil, ServiceErrors.unknownUrl)
            return
        }
        
        let teamData = try? JSONEncoder().encode(teamData)

        guard let teamData = teamData else {
            completionHandler(nil, ServiceErrors.dataSerializationFailed)
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
                        throw ServiceErrors.server500(message: (String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong"))
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let teamModel = try decoder.decode(TeamModel.self, from: data)
                    completionHandler(teamModel, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func getTeamsByTeamIds(teamIds: [String], completionHandler: @escaping((([TeamModel]?, Error?) -> Void))) {
        let queryString = Networking.helpers.createQueryString(items: teamIds)
        guard let url = Networking.createUrl(endPoint: "team?teamIds=\(queryString)") else {
            completionHandler(nil, ServiceErrors.unknownUrl)
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
                    completionHandler(nil, error)
                    return
                }
            }
        }
        
    }
}
