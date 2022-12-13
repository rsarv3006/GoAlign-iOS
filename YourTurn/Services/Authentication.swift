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
    
    static func createAccount(form: SignUpCompletedForm, completion: @escaping(((UserModel?, Error?) -> Void))) {
        Auth.auth().createUser(withEmail: form.emailAddress, password: form.password) { dataResult, error in
            guard error == nil else {
                completion(nil, error)
                self.signOut()
                return
            }

            let currentUser = self.getCurrentFirebaseUser()

            if let userId = currentUser?.uid, let email = currentUser?.email {
                let createUserDto = CreateUserDto(userId: userId, username: form.username, email: email)

                UserService.createUser(with: createUserDto) { user, error in
                    completion(user, error)
                }
            } else {
                self.signOut()
                Auth.auth().currentUser?.delete(completion: { error in
                    completion(nil, ServiceErrors.custom(message: "Issue with authentication, please try again"))
                    return
                })
            }
        }
    }
    
    static func signInToAccount(form: SignInCompletedForm, completion: @escaping(((UserModel?, Error?) -> Void))) {
        Auth.auth().signIn(withEmail: form.emailAddress, password: form.password) { authResult, error in
            guard error == nil else {
                completion(nil, error)
                self.signOut()
                return
            }
            
            UserService.getCurrentUser { user, error in
                completion(user, error)
            }
        }
    }
    
    static func getToken() async throws -> String? {
        let token = try await self.getCurrentFirebaseUser()?.getIDTokenResult(forcingRefresh: true)
        return token?.token
    }
    
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
    
    static func requestPasswordReset(emailAddress: String, completion: @escaping((Error?) -> Void)) {
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { error in
            completion(error)
        }
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
