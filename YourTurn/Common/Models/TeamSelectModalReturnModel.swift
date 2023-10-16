//
//  TeamSelectModalReturnModel.swift
//  YourTurn
//
//  Created by rjs on 8/18/22.
//

import Foundation

struct TeamSelectModalReturnModel {
    let team: TeamModel
    let teamMember: UserModel

    init(team: TeamModel, teamMember: UserModel) {
        self.team = team
        self.teamMember = teamMember
    }
}
