//
//  User.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

enum UserService {
    static func createUser(with user: CreateUserDto) async throws -> UserModel {
        guard let url = Networking.createUrl(endPoint: "user") else {
            throw ServiceErrors.unknownUrl
        }
        
        let userData = try? JSONEncoder().encode(user)
        
        guard let userData = userData else {
            throw ServiceErrors.dataSerializationFailed(dataObjectName: "CreateUserDto")
        }
        
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
    
    static func getCurrentUser(completionHandler: @escaping ((UserModel?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "user/current") else {
            completionHandler(nil, ServiceErrors.unknownUrl)
            return
        }
        
        Networking.get(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 200 {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                        
                        let userModel = try decoder.decode(UserModel.self, from: data)
                        completionHandler(userModel, nil)
                    } else {
                        let decoder = JSONDecoder()
                        let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                        throw ServiceErrors.custom(message: serverError.message)
                    }
                } catch {
                    Logger.log(logLevel: .Verbose, name: Logger.Events.User.fetchFailed, payload: ["error": error, "user": "current User"])
                    AuthenticationService.signOut()
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func getCurrentUser() async throws -> UserModel {
        guard let url = Networking.createUrl(endPoint: "user/current") else {
            throw ServiceErrors.unknownUrl
        }
        
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
        guard let url = Networking.createUrl(endPoint: "user") else {
            throw ServiceErrors.unknownUrl
        }
        
        let (_, response) = try await Networking.delete(url: url)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 204 {
            return true
        }
        
        return false
    }
}
