//
//  Authentication.swift
//  YourTurn
//
//  Created by rjs on 7/24/22.
//

import Foundation
import Firebase

struct AuthenticationService {
    static func getCurrentFirebaseUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func doesCurrentUserExist() -> Bool {
        return self.getCurrentFirebaseUser() !== nil
    }
    
    static func fetchJwtWithCode(dto: FetchJwtDtoModel) async throws -> FetchJwtDtoReturnModel {
        do {
            let url = try Networking.createUrl(endPoint: "auth/code")
            
            let encodedBody = try JSONEncoder().encode(dto)
            
            let (data, response) = try await Networking.post(url: url, body: encodedBody, noAuth: true)
            
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE

                
                return try decoder.decode(FetchJwtDtoReturnModel.self, from: data)
            } else {
                let decoder = JSONDecoder()
                let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.message)
            }
        } catch {
            print(error.localizedDescription)
            self.signOut()
            try await Auth.auth().currentUser?.delete()
            throw error
        }
    }
    
    static func createAccount(form: SignUpCompletedForm) async throws -> CreateAccountReturnModel {
        do {
            let createUserDto = CreateUserDto(username: form.username, email: form.emailAddress)
            
            let url = try Networking.createUrl(endPoint: "auth/register")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            let createUserBody = try encoder.encode(createUserDto)
            
            let (data, response) = try await Networking.post(url: url, body: createUserBody, noAuth: true)
            
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                print("201 response created")
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = CUSTOM_ISO_DECODE
               
                
                
                let userModel = try decoder.decode(CreateAccountReturnModel.self, from: data)
                return userModel
            } else if let response = response as? HTTPURLResponse, response.statusCode == 400 {
                let decoder = JSONDecoder()
                let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.message)
            } else {
                let decoder = JSONDecoder()
                let serverError = try decoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.message)
            }
        } catch {
            print(error.localizedDescription)
            self.signOut()
            try await Auth.auth().currentUser?.delete()
            throw error
        }
    }
    
    static func signInToAccount(form: SignInCompletedForm) async throws -> UserModel {
        do {
            try await Auth.auth().signIn(withEmail: form.emailAddress, password: form.password)
            if let userModel = UserService.shared.currentUser {
                return userModel
            } else {
                throw ServiceErrors.custom(message: "User Not Found")
            }
        } catch {
            self.signOut()
            throw error
        }
    }
    
    static func getToken() async throws -> String {
        let token = try await self.getCurrentFirebaseUser()?.getIDTokenResult(forcingRefresh: true)
        guard let token = token else {
            throw ServiceErrors.custom(message: "Token Not Found")
        }
        return token.token
    }
    
    // TODO: Remove this function when it's no longer needed
    static func getToken(completion: @escaping((String?, Error?) -> Void)) {
        self.getCurrentFirebaseUser()?.getIDTokenForcingRefresh(true, completion: completion)
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
