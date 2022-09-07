//
//  TeamInviteModel.swift
//  YourTurn
//
//  Created by rjs on 8/28/22.
//

import Foundation

class TeamInviteModel: Codable {
    let inviteId: String
    let teamId: String
    let emailAddressToInvite: String
    let inviteStatus: String
    let userId: String?
    let team: TeamModel
    let creatorUserId: String
    let creator: UserModel
}

class TeamInviteDisplayModel {
    let inviteModel: TeamInviteModel
    var areButtonsVisible: Bool = false
    
    init (inviteModel: TeamInviteModel) {
        self.inviteModel = inviteModel
    }
}
