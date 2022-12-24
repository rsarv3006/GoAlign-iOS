//
//  ChangeTeamManagerCellVM.swift
//  YourTurn
//
//  Created by rjs on 12/22/22.
//

import Foundation

class ChangeTeamManagerUserCellVM {
    let teamMemberName: String
    let teamMemberEmail: String
    
    init(teamMember: UserModel) {
        teamMemberName = teamMember.username
        teamMemberEmail = teamMember.email
    }
}
