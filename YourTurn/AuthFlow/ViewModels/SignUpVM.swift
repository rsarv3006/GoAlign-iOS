//
//  SignUpVM.swift
//  YourTurn
//
//  Created by rjs on 7/24/22.
//

import Foundation
import UIKit
import Combine

class SignUpVM {
    let welcomeLabelText: String = "Sign Up"
    let buttonTextGoToSignIn: String = "Already have an Account? \nClick here to Sign In!"
    
    let signUpSubject = PassthroughSubject<Result<UserModel?, Error>, Never>()
    
    func signUp(form: SignUpCompletedForm) {
        Task {
            do {
                let user = try await AuthenticationService.createAccount(form: form)
                signUpSubject.send(.success(user))
            } catch {
                signUpSubject.send(.failure(error))
            }
        }
    }
}
