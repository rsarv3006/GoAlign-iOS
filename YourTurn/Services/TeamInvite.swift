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

struct TeamInviteService {
    static func getTeamInvitesByCurrentUser(completionHandler: @escaping(([TeamInviteModel]?, Error?) -> Void)) {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            completionHandler(nil, TeamInviteError.custom(message: "API_URL is malformed."))
            return
        }
        
        let url = URL(string: "\(baseUrl)teamInvite/byCurrentUser")
        
        guard let url = url else {
            completionHandler(nil, TeamInviteError.custom(message: "Invalid URL"))
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
                    Logger.log(logLevel: .Verbose, message: "Error pulling team invites by current user: \(error)")
                    completionHandler(nil, error)
                    return
                }
            }
        }
    }
}
