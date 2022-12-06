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
        AuthenticationService.createAccount(form: form) { [weak self] user, error in
            if let user = user {
                self?.signUpSubject.send(.success(user))
            } else if let error = error {
                self?.signUpSubject.send(.failure(error))
            } else {
                self?.signUpSubject.send(.failure(ServiceErrors.custom(message: "Something is busted and I have no idea what")))
            }
        }
    }
}

