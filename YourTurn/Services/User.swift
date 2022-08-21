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

struct UserService {
    static func createUser(with user: CreateUserDto, completionHandler: @escaping((UserModel?, Error?) -> Void)) {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            completionHandler(nil, UserError.custom(message: "API_URL is malformed."))
            return
        }
        
        let url = URL(string: "\(baseUrl)user")
        
        guard let url = url else {
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
                return
            }
            
                
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode == 500 {
                        throw UserError.custom(message: (String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong"))
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let userModel = try decoder.decode(UserModel.self, from: data)
                    completionHandler(userModel, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, message: "FAILED to createUser: \(error)")
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    static func getCurrentUser(completionHandler: @escaping((UserModel?, Error?) -> Void)) {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            completionHandler(nil, UserError.custom(message: "API_URL is malformed."))
            return
        }
        
        let url = URL(string: "\(baseUrl)user/current")
        
        guard let url = url else {
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
                        throw UserError.custom(message: (String(data: data, encoding: String.Encoding.utf8) ?? "Something went wrong"))
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
                    
                    let userModel = try decoder.decode(UserModel.self, from: data)
                    completionHandler(userModel, nil)
                } catch {
                    Logger.log(logLevel: .Verbose, message: "Failed to fetch current user: \(error)")
                    completionHandler(nil, error)
                }
            }
        }
    }
}
