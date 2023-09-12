//
//  StatsService.swift
//  YourTurn
//
//  Created by rjs on 12/1/22.
//

import Foundation

struct StatsService {
    static func getTeamStats(teamId: UUID) async throws -> TeamStatsModel {
        let url = try Networking.createUrl(endPoint: "stats/team/\(teamId.uuidString)")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let teamStatsReturn = try GlobalDecoder.decode(TeamStatsReturnModel.self, from: data)
            return teamStatsReturn.stats
        } else {
            let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
        
    }
}
