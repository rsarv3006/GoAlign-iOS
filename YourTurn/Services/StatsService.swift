//
//  StatsService.swift
//  YourTurn
//
//  Created by rjs on 12/1/22.
//

import Foundation

enum StatsError: Error {
    case custom(message: String)
}

struct StatsService {
    static func getTeamStats(teamId: String, completionHandler: @escaping((TeamStatsModel?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "stats/team/\(teamId)") else {
            completionHandler(nil, StatsError.custom(message: "Bad URL"))
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
                    
                    let teamStats = try decoder.decode(TeamStatsModel.self, from: data)
                    completionHandler(teamStats, nil)
                } catch {
                    completionHandler(nil, error)
                    return
                }
            }
        }
    }
}
