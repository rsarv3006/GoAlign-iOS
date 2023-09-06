//
//  SignInCompletedForm.swift
//  YourTurn
//
//  Created by rjs on 8/11/22.
//

import Foundation

struct SignInCompletedForm: Codable {
    let email: String
    
    init(fromDict dict: [String : Any]) throws {
        guard let email = dict[FormField.signInEmailAddress.rawValue] as? String
        else {
            throw ValidationError.custom(message: "Something went wrong with the sign in form")
        }
        
        self.email = email
        
    }
}
