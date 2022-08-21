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
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            completionHandler(nil, TeamError.custom(message: "API_URL is malformed."))
            return
        }
        
        let url = URL(string: "\(baseUrl)team/byCurrentUser")
        
        guard let url = url else {
            completionHandler(nil, TeamError.custom(message: ""))
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
                    print(teams[0].teamMembers[0].username)
                    completionHandler(teams, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, message: "Error pulling teams by current user: \(error)")
                    completionHandler(nil, error)
                    return
                }
            }
        }

    }
}
