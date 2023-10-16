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

    let signUpSubject = PassthroughSubject<Result<LoginRequestModel?, Error>, Never>()

    func signUp(form: SignUpCompletedForm) {
        Task {
            do {
                let createAccountReturn = try await AuthenticationService.createAccount(form: form)
                signUpSubject.send(.success(createAccountReturn))
            } catch {
                signUpSubject.send(.failure(error))
            }
        }
    }
}
