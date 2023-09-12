//
//  AppState.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 9/3/23.
//

import Foundation
import JWTDecode

class AppState {
    // TODO: passthrough on accessToken update
    
    private static var shared: AppState?
    
    private init(accessToken: String? = nil, refreshToken: String? = nil) {
        do {
            if let accessToken, let refreshToken {
                self.accessToken = accessToken
                self.refreshToken = refreshToken
                // TODO: fix this after server implements refresh tokens
                try KeychainService.storeTokens(accessToken, "refreshToken", Date())
            } else {
                self.accessToken = try KeychainService.getAccessToken()
                self.refreshToken = try KeychainService.getRefreshToken()
            }
            try self.updateUserFromToken(accessToken: self.accessToken)
        } catch {
            print(self.accessToken)
            print(error.localizedDescription)
            print("do something")
        }
    }
    
    private static func shouldInitWithTokens(_ accessToken: String?, _ refreshToken: String?) -> Bool {
        if  (accessToken != nil || refreshToken != nil) {
            return true
        }
        
        return false
    }
    
    @discardableResult
    static func getInstance(accessToken: String? = nil, refreshToken: String? = nil) -> AppState {
        if shared == nil {
            self.shared = AppState(accessToken: accessToken, refreshToken: refreshToken)
        } else if shouldInitWithTokens(accessToken, refreshToken) {
            self.shared = AppState(accessToken: accessToken, refreshToken: refreshToken)
        }
        
        return shared!
    }
    
    private(set) var currentUser: UserModel?
    private var accessToken: String?
    private var refreshToken: String?
    
    
    private func updateUserFromToken(accessToken: String?) throws {
        guard let accessToken else { throw ServiceErrors.custom(message: "accessToken is nil")
        }
        
        let jwt = try decode(jwt: accessToken)
        let body = jwt.body
        
        guard let jwtUserDict = body["User"] as? [String: Any] else {
            throw ServiceErrors.custom(message: "User is not a dictionary")
        }
        
        let userIdString = jwtUserDict["user_id"] as? String
        let username = jwtUserDict["username"] as? String
        let email = jwtUserDict["email"] as? String
        let isActive = jwtUserDict["is_active"] as? Bool
        let isEmailVerified = jwtUserDict["is_email_verified"] as? Bool
        let createdAtString = jwtUserDict["created_at"] as? String
        
        guard let createdAtString else {
            throw ServiceErrors.custom(message: "created_at is not a string")
        }
        
        let createAtDate = try decodeISO8601DateFromString(dateString: createdAtString)
        
        if let userIdString, let userId = UUID(uuidString: userIdString), let username, let email, let isActive, let isEmailVerified {
            
            currentUser = UserModel(userId: userId, createdAt: createAtDate, username: username, email: email, isActive: isActive, isEmailVerified: isEmailVerified)
        } else {
            currentUser = nil
            throw ServiceErrors.custom(message: "user is unparseable")
        }
    }
    
    func getAccessToken() async throws -> String {
        if self.accessToken == nil {
            try self.loadTokensFromKeychain()
        }
        
        guard let accessToken = self.accessToken, !accessToken.isEmpty else { throw TokenService.TokenServiceError.accessTokenNotFound }
        let jwt = try decode(jwt: accessToken)
        
        if jwt.expired {
            let result = try await TokenService.refreshTokens(currentAccessToken: self.accessToken, currentRefreshToken: self.refreshToken)
            self.accessToken = result.accessToken
            self.refreshToken = result.refreshToken
            try self.updateUserFromToken(accessToken: self.accessToken)
        }
        
        if let token = self.accessToken {
            return token
        } else {
            throw TokenService.TokenServiceError.accessTokenNotFound
        }
    }
    
    private func loadTokensFromKeychain() throws {
        do {
            let accessToken = try KeychainService.getAccessToken()
            self.accessToken = accessToken
            try updateUserFromToken(accessToken: accessToken)
            self.refreshToken = try KeychainService.getRefreshToken()
        } catch {
            print(error)
            throw TokenService.TokenServiceError.failedToLoadTokensFromKeychain
        }
    }
    
    static func resetState() {
        shared = nil
        
        KeychainService.reset()
    }
}
