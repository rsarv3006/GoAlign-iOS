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
    
    let signInSubject = PassthroughSubject<UserModel?, Error>()
    
    func signIn(form: SignInCompletedForm) {
        AuthenticationService.signInToAccount(form: form) { [weak self] user, error in
            if let user = user {
                self?.signInSubject.send(user)
            } else if let error = error {
                self?.signInSubject.send(completion: .failure(error))
            } else {
                self?.signInSubject.send(completion: .failure(AuthenticationError.custom(message: "Something is busted and I have no idea what")))
            }
        }
    }
}
