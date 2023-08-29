//
//  SignUpCompletedForm.swift
//  YourTurn
//
//  Created by rjs on 7/24/22.
//

import Foundation

struct SignUpCompletedForm {
    let username: String
    let emailAddress: String
    
    init(fromDict dict: [String : Any]) throws {
        guard let username = dict[FormField.signUpUserName.rawValue] as? String,
              let emailAddress = dict[FormField.signUpEmailAddress.rawValue] as? String
        else {
            throw ValidationError.custom(message: "Something went wrong with the sign up form")
        }
        
        self.username = username
        self.emailAddress = emailAddress
    }
}
