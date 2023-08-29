//
//  CreateAccountReturnModel.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 8/27/23.
//

import Foundation

struct CreateAccountReturnModel: Codable {
    let user: UserModel
}

//{"message":"User created successfully","success":true,"user":{"user_id":"36e298ef-6531-40aa-b85f-6e86133382fd","username":"meep","email":"meep@yeet.com","is_active":true,"is_email_verified":false}}
//
