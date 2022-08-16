//
//  Authentication.swift
//  YourTurn
//
//  Created by rjs on 7/24/22.
//

import Foundation
import Firebase

enum AuthenticationError: Error {
    case custom(message: String)
}

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
                return
            }

            let currentUser = self.getCurrentFirebaseUser()

            if let userId = currentUser?.uid, let email = currentUser?.email {
                let createUserDto = CreateUserDto(userId: userId, username: form.username, email: email)

                UserService.createUser(with: createUserDto) { user, error in
                    completion(user, error)
                }
            } else {
                completion(nil, AuthenticationError.custom(message: "Issue with authentication, please try again"))
                return
            }
        }
    }
    
    static func signInToAccount(form: SignInCompletedForm, completion: @escaping(((UserModel?, Error?) -> Void))) {
        Auth.auth().signIn(withEmail: form.emailAddress, password: form.password) { authResult, error in
            guard error == nil else {
                completion(nil, error)
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
            Logger.log(logLevel: .Prod, message: "\(error)")
        }
        
    }
}
