//
//  TokenService.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 8/27/23.
//

import Foundation
import JWTDecode

final class TokenService {
    private var accessToken: String?
    private var refreshToken: String?
    private var expiration: Date?
    private var anonToken: String?
    
    private init() {}
    
    func getAccessToken() async throws -> String {
        if self.accessToken == nil {
            try self.loadTokensFromKeychain()
        }
        
        if try self.isTokenExpired() {
            try await self.refreshAccessToken()
        }

        if let token = self.accessToken {
            return token
        } else {
            throw TokenServiceError.accessTokenNotFound
        }
    }
    
    func getRefreshToken() async throws -> String {
        if let refreshToken = self.refreshToken {
            return refreshToken
        } else {
            throw TokenServiceError.refreshTokenNotFound
        }
    }
    
    func getExpiration() async throws -> Date {
        if let expirationDate = self.expiration {
            return expirationDate
        } else {
            throw TokenServiceError.expirationDateNotFound
        }
    }
    
    func isTokenExpired() throws -> Bool {
        if let expirationDate = self.expiration {
            print(expirationDate.ISO8601Format())
            return expirationDate < Date()
        } else {
            throw TokenServiceError.expirationDateNotFound
        }
    }
    
    private func loadTokensFromKeychain() throws {
        do {
            let accessToken = try KeychainService.getAccessToken()
            self.accessToken = accessToken
            self.refreshToken = try KeychainService.getRefreshToken()
            try UserService.shared.updateUserFromToken(accessToken: accessToken)
        } catch {
            print(error)
            throw TokenServiceError.failedToLoadTokensFromKeychain
        }
    }
    
    private func refreshAccessToken() async throws {
        if self.refreshToken == nil {
            self.refreshToken = try? KeychainService.getRefreshToken()
        }
        
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
        
        self.accessToken = nil
    }
    
    
    func setToken(accessToken: String, refreshToken: String) throws {
        let jwt = try decode(jwt: accessToken)
        let body = jwt.body
        
        guard let expirationDate = jwt.expiresAt else {
            throw ServiceErrors.custom(message: "Expiration date is not valid.")
        }
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiration = expirationDate
        
        try KeychainService.storeTokens(accessToken, refreshToken, expirationDate)
        try UserService.shared.updateUserFromToken(accessToken: accessToken)
    }
    
    func reset() {
        self.accessToken = nil
        self.refreshToken = nil
        self.expiration = nil
        
        KeychainService.reset()
        
        UserService.shared.resetStoredUser()
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

extension TokenService {
    static let shared = TokenService()
}

