//
//  RefreshTokensReturnDto.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 9/4/23.
//

import Foundation

struct RefreshTokensReturnDto: Codable {
    let accessToken: String
    let refreshToken: String
}
