//
//  TeamUsersTabViewCellVM.swift
//  YourTurn
//
//  Created by rjs on 11/8/22.
//

import Foundation

struct TeamUsersTabViewCellVM {
    
    let username: String
    
    init(user: UserModel) {
        self.username = user.username
    }
    
}
