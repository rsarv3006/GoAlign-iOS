//
//  CreateAccountReturnModel.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 8/27/23.
//

import Foundation

struct CreateAccountReturnModel: Codable {
    let loginRequestId: UUID
    let userId: UUID
}
