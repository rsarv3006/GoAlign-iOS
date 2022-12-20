//
//  User.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

enum UserService {
    static func createUser(with user: CreateUserDto, completionHandler: @escaping ((UserModel?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "user") else {
            completionHandler(nil, ServiceErrors.unknownUrl)
            return
        }
        
        let userData = try? JSONEncoder().encode(user)
        
        guard let userData = userData else {
            completionHandler(nil, ServiceErrors.dataSerializationFailed(dataObjectName: "CreateUserDto"))
            return
        }
        
        Networking.post(url: url, body: userData) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                AuthenticationService.signOut()
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 201 {
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
                    Logger.log(logLevel: .Verbose, name: Logger.Events.User.createFailed, payload: ["error": error, "email": user.email])
                    AuthenticationService.signOut()
                    completionHandler(nil, error)
                }
            }
        }
    }
    
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
    
    static func deleteCurrentUser(completionHandler: @escaping ((Bool, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "user") else {
            completionHandler(false, ServiceErrors.unknownUrl)
            return
        }
        
        Networking.delete(url: url) { _, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    completionHandler(true, nil)
                    return
                } else {
                    completionHandler(false, error)
                }
            }
        }
    }
}
