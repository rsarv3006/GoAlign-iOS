//
//  SignInVM.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import Foundation
import Combine

class SignInVM {
    let signInLabelTextString = "Sign In"
    let buttonTextGoToSignUp: String = "Don't have an account? \nClick here to Sign Up!"
    
    let signInSubject = PassthroughSubject<Result<UserModel?, Error>, Never>()
    
    func signIn(form: SignInCompletedForm) {
        Task {
            do {
                let user = try await AuthenticationService.signInToAccount(form: form)
                self.signInSubject.send(.success(user))
            } catch {
                self.signInSubject.send(.failure(error))
            }
        }
    }
}
