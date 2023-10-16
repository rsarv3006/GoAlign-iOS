//
//  LoggingEvent.swift
//  YourTurn
//
//  Created by Robby on 10/29/22.
//

import Foundation

class CreateLoggingEventDto: Codable {
    let name: String
    let payload: Data?
    init(name: String, payload: [String: String]?) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let payloadData = try? encoder.encode(payload)

        self.name = name
        self.payload = payloadData
    }
}
