//
//  User.swift
//  YourTurn
//
//  Created by rjs on 7/28/22.
//

import Foundation

enum UserError: Error {
    case custom(message: String)
}

enum UserService {
    static func createUser(with user: CreateUserDto, completionHandler: @escaping ((UserModel?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "user") else {
            completionHandler(nil, UserError.custom(message: "Bad URL"))
            return
        }
        
        let userData = try? JSONEncoder().encode(user)

        guard let userData = userData else {
            completionHandler(nil, UserError.custom(message: "Serialization of Create User DTO failed"))
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
                    if response.statusCode == 500 {
                        throw UserError.custom(message: String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong")
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let userModel = try decoder.decode(UserModel.self, from: data)
                    completionHandler(userModel, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, message: "FAILED to createUser: \(error)")
                    AuthenticationService.signOut()
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func getCurrentUser(completionHandler: @escaping ((UserModel?, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "user/current") else {
            completionHandler(nil, UserError.custom(message: "Bad URL"))
            return
        }
        
        Networking.get(url: url) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 500 {
                        throw UserError.custom(message: String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong")
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let userModel = try decoder.decode(UserModel.self, from: data)
                    completionHandler(userModel, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, message: "Failed to fetch current user: \(error)")
                    AuthenticationService.signOut()
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func deleteCurrentUser(completionHandler: @escaping ((Bool, Error?) -> Void)) {
        guard let url = Networking.createUrl(endPoint: "user") else {
            completionHandler(false, UserError.custom(message: "Bad URL"))
            return
        }
        
        Networking.delete(url: url) { _, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completionHandler(true, nil)
                    return
                } else {
                    completionHandler(false, error)
                }
            }
        }
    }
}
