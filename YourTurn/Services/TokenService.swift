//
//  TokenService.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 8/27/23.
//

import Foundation
import JWTDecode

final class TokenService {
    static func isTokenExpired(expirationDate: Date?) throws -> Bool {
        if let expirationDate {
            print(expirationDate.ISO8601Format())
            return expirationDate < Date()
        } else {
            throw TokenService.TokenServiceError.expirationDateNotFound
        }
    }
    
    static func refreshTokens(currentAccessToken: String?, currentRefreshToken: String?) async throws -> RefreshTokensReturnDto {
        
        //        if let refreshToken = self.refreshToken {
        //            let refreshTokenRequest = RefreshTokenRequest(refreshToken: refreshToken)
        //            let refreshTokenTask = Task {
        //                do {
        //                    let response = try await ApiClient.shared.refreshToken(refreshTokenRequest)
        //                    self.token = response.accessToken
        //                    self.refreshToken = response.refreshToken
        //                    self.expirationDate = response.expirationDate
        //                    try await KeychainService.storeTokens(
        //                        accessToken: response.accessToken,
        //                        refreshToken: response.refreshToken,
        //                        expirationDate: response.expirationDate)
        //                } catch {
        //                    print("Error refreshing token: \(error)")
        //                }
        //            }
        //        }
        return RefreshTokensReturnDto(accessToken: "", refreshToken: "")
    }
}

extension TokenService {
    enum TokenServiceError: Error {
        case accessTokenNotFound
        case refreshTokenNotFound
        case expirationDateNotFound
        case anonTokenNotFound
        case failedToLoadTokensFromKeychain
    }
}

