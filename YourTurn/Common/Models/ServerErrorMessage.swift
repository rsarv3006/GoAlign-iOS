//
//  ServerErrorMessage.swift
//  YourTurn
//
//  Created by rjs on 12/12/22.
//

import Foundation

struct ServerErrorMessage: Codable {
    let statusCode: Int
    let message: String
}
