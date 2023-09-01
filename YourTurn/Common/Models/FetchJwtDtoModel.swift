//
//  FetchJwtDtoModel.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 8/27/23.
//

import Foundation

struct FetchJwtDtoModel: Codable {
    let loginCodeRequestId: UUID
    let userId: UUID
    let loginRequestToken: String
}
