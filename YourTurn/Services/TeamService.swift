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
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 200 {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                        
                        let teams = try decoder.decode([TeamModel].self, from: data)
                        completionHandler(teams, nil)
                    } else {
                        let decoder = JSONDecoder()
                        let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                        throw ServiceErrors.custom(message: serverError.message)
                    }
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
            completionHandler(nil, ServiceErrors.dataSerializationFailed(dataObjectName: "CreateTeamDto"))
            return
        }
        
        Networking.post(url: url, body: teamData) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 201 {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                        
                        let teamModel = try decoder.decode(TeamModel.self, from: data)
                        completionHandler(teamModel, nil)
                    } else {
                        let decoder = JSONDecoder()
                        let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                        throw ServiceErrors.custom(message: serverError.message)
                    }
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
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 200 {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                        
                        let teams = try decoder.decode([TeamModel].self, from: data)
                        completionHandler(teams, nil)
                    } else {
                        let decoder = JSONDecoder()
                        let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                        throw ServiceErrors.custom(message: serverError.message)
                    }
                } catch {
                    completionHandler(nil, error)
                    return
                }
            }
        }
        
    }
    
    static func deleteTeam(teamId: String, completionHandler: @escaping(((Bool, Error?) -> Void))) {
        guard let url = Networking.createUrl(endPoint: "team/\(teamId)") else {
            completionHandler(false, ServiceErrors.unknownUrl)
            return
        }
        
        Networking.delete(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 204 {
                        completionHandler(true, nil)
                    } else {
                        let decoder = JSONDecoder()
                        let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                        throw ServiceErrors.custom(message: serverError.message)
                    }
                } catch {
                    completionHandler(false, error)
                    return
                }
            }
        }
    }
    
    static func removeUserFromTeam(teamId: String, userToRemove: String, completionHandler: @escaping(((Bool, Error?) -> Void))) {
        guard let url = Networking.createUrl(endPoint: "team/removeUserFromTeam") else {
            completionHandler(false, ServiceErrors.unknownUrl)
            return
        }
        
        let removeUserDto = RemoveUserFromTeamDto(userToRemove: userToRemove, teamId: teamId)
        
        let removeUserData = try? JSONEncoder().encode(removeUserDto)
        
        guard let removeUserData = removeUserData else {
            completionHandler(false, ServiceErrors.dataSerializationFailed(dataObjectName: "CreateTeamDto"))
            return
        }
        
        Networking.post(url: url, body: removeUserData) { data, response, error in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 204 {
                        completionHandler(true, nil)
                    } else {
                        let decoder = JSONDecoder()
                        let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                        throw ServiceErrors.custom(message: serverError.message)
                    }
                } catch {
                    completionHandler(false, error)
                }
            }
        }
    }
}
