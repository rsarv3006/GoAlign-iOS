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
    
    static func createAccount(form: SignUpCompletedForm) async throws -> UserModel {
        do {
            try await Auth.auth().createUser(withEmail: form.emailAddress, password: form.password)
            
            let currentUser = self.getCurrentFirebaseUser()
            
            guard let userId = currentUser?.uid, let email = currentUser?.email else {
                throw ServiceErrors.custom(message: "Unable to find email and userid.")
            }
            
            let createUserDto = CreateUserDto(userId: userId, username: form.username, email: email)
            let userModel = try await UserService.createUser(with: createUserDto)
            return userModel
            
        } catch {
            self.signOut()
            try await Auth.auth().currentUser?.delete()
            throw error
        }
    }
    
    static func signInToAccount(form: SignInCompletedForm) async throws -> UserModel {
        do {
            try await Auth.auth().signIn(withEmail: form.emailAddress, password: form.password)
            let userModel = try await UserService.getCurrentUser()
            return userModel
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
