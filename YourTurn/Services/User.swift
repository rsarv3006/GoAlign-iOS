//
//  User.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

enum UserService {
    static func createUser(with user: CreateUserDto) async throws -> UserModel {
        let url = try Networking.createUrl(endPoint: "user")
        
        let userData = try JSONEncoder().encode(user)
        
        let (data, response) = try await Networking.post(url: url, body: userData)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 201 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
            
            let userModel = try decoder.decode(UserModel.self, from: data)
            return userModel
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            Logger.log(logLevel: .Verbose, name: Logger.Events.User.createFailed, payload: ["error": serverError.message, "email": user.email])
            AuthenticationService.signOut()
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func getCurrentUser() async throws -> UserModel {
        let url = try Networking.createUrl(endPoint: "user/current")
        
        let (data, response) = try await Networking.get(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
            
            let userModel = try decoder.decode(UserModel.self, from: data)
            return userModel
        } else {
            let decoder = JSONDecoder()
            let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
            throw ServiceErrors.custom(message: serverError.message)
        }
    }
    
    static func deleteCurrentUser() async throws -> Bool {
        let url = try Networking.createUrl(endPoint: "user")
        
        let (_, response) = try await Networking.delete(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return true
        }
        
        return false
    }
}
