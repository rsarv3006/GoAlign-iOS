//
//  SignInCompletedForm.swift
//  YourTurn
//
//  Created by rjs on 8/11/22.
//

import Foundation

struct SignInCompletedForm {
    let emailAddress: String
    let password: String
    
    init(fromDict dict: [String : Any]) throws {
        guard let emailAddress = dict[FormField.signInEmailAddress.rawValue] as? String,
              let password = dict[FormField.signInPassword.rawValue] as? String
        else {
            throw ValidationError.custom(message: "Something went wrong with the sign in form")
        }

        self.emailAddress = emailAddress
        self.password = password
    }
}
