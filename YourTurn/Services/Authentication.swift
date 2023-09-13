//
//  Authentication.swift
//  YourTurn
//
//  Created by rjs on 7/24/22.
//

import Foundation
import Firebase

struct AuthenticationService {
    static func fetchJwtWithCode(dto: FetchJwtDtoModel) async throws -> FetchJwtDtoReturnModel {
        do {
            let url = try Networking.createUrl(endPoint: "v1/auth/code")
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy  = .convertToSnakeCase
            
            let encodedBody = try encoder.encode(dto)
            
            let (data, response) = try await Networking.post(url: url, body: encodedBody, noAuth: true)
            
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                return try GlobalDecoder.decode(FetchJwtDtoReturnModel.self, from: data)
            } else {
                let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.message)
            }
        } catch {
            print(error.localizedDescription)
            self.signOut()
            try await Auth.auth().currentUser?.delete()
            throw error
        }
    }
    
    static func createAccount(form: SignUpCompletedForm) async throws -> LoginRequestModel {
        do {
            let createUserDto = CreateUserDto(username: form.username, email: form.emailAddress)
            
            let url = try Networking.createUrl(endPoint: "v1/auth/register")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            let createUserBody = try encoder.encode(createUserDto)
            
            let (data, response) = try await Networking.post(url: url, body: createUserBody, noAuth: true)
            
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                let userModel = try GlobalDecoder.decode(LoginRequestModel.self, from: data)
                return userModel
            } else if let response = response as? HTTPURLResponse, response.statusCode == 400 {
                let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.message)
            } else {
                let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.message)
            }
        } catch {
            print(error.localizedDescription)
            self.signOut()
            // TODO: fix this line below
            try await Auth.auth().currentUser?.delete()
            throw error
        }
    }
    
    static func signInToAccount(form: SignInCompletedForm) async throws -> LoginRequestModel {
        do {
            let url = try Networking.createUrl(endPoint: "v1/auth/login")
           
            let encoder = JSONEncoder()
           
            let signInBody = try encoder.encode(form)
            
            let (data, response) = try await Networking.post(url: url, body: signInBody, noAuth: true)
            
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                let userModel = try GlobalDecoder.decode(LoginRequestModel.self, from: data)
                return userModel
            } else if let response = response as? HTTPURLResponse, response.statusCode == 400 {
                let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.message)
            } else {
                let serverError = try GlobalDecoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.message)
            }
        } catch {
            self.signOut()
            throw error
        }
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            Logger.log(logLevel: .Prod, name: Logger.Events.Auth.signOutFailed, payload: ["error": error])
        }
        
    }
    
    static func checkForStandardErrors(error: Error) -> String {
        var returnErrorString = error.localizedDescription
        for errorReference in AuthErrorHandling.errors {
            if String(describing: error).contains(errorReference.keyword) {
                returnErrorString = errorReference.userFacingErrorString
            }
        }
        return returnErrorString
    }
    
    static func requestPasswordReset(emaillAddress: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: emaillAddress)
    }
    

    
    struct AuthErrorHandling {
        struct StandardErrorKeywords {
            static let userNotFound = "ERROR_USER_NOT_FOUND"
            static let incorrectPassword = "ERROR_WRONG_PASSWORD"
            static let emailAlreadyInUse = "ERROR_EMAIL_ALREADY_IN_USE"
            static let invalidEmail = "ERROR_INVALID_EMAIL"
        }
        
        struct UserFacingErrorStrings {
            static let emailOrPasswordIncorrect = "Email or Password is Incorrect"
            static let emailAlreadyInuse = "This email already has an account. Please sign in instead."
            static let unknownError = "Unknown Error"
        }
        
        static let errors: [AuthStandardErrorReference] = [
            AuthStandardErrorReference(keyword: StandardErrorKeywords.userNotFound, userFacingErrorString: UserFacingErrorStrings.emailOrPasswordIncorrect),
            AuthStandardErrorReference(keyword: StandardErrorKeywords.incorrectPassword, userFacingErrorString: UserFacingErrorStrings.emailOrPasswordIncorrect),
            AuthStandardErrorReference(keyword: StandardErrorKeywords.emailAlreadyInUse, userFacingErrorString: UserFacingErrorStrings.emailAlreadyInuse),
            AuthStandardErrorReference(keyword: StandardErrorKeywords.invalidEmail, userFacingErrorString: UserFacingErrorStrings.emailOrPasswordIncorrect)
        ]
    }
}

struct AuthStandardErrorReference {
    let keyword: String
    let userFacingErrorString: String
}
