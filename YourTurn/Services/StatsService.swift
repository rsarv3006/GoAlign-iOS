//
//  StatsService.swift
//  YourTurn
//
//  Created by rjs on 12/1/22.
//

import Foundation

struct StatsService {
    static func getTeamStats(teamId: String, completionHandler: @escaping((TeamStatsModel?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "stats/team/\(teamId)") else {
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
                        
                        let teamStats = try decoder.decode(TeamStatsModel.self, from: data)
                        completionHandler(teamStats, nil)
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
}
