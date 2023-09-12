//
//  TeamInviteModel.swift
//  YourTurn
//
//  Created by rjs on 8/28/22.
//

import Foundation

class TeamInviteGetByCurrentUserReturnModel: Codable {
    let invites: [TeamInviteModel]
    let message: String
}

class TeamInviteModel: Codable {
    let teamInviteId: UUID
    let teamId: UUID
    let email: String
    let status: String
    let team: TeamModel
    let inviteCreatorId: UUID
    let inviteCreator: UserModel
}

class TeamInviteDisplayModel {
    let inviteModel: TeamInviteModel
    var areButtonsVisible: Bool = false
    
    init (inviteModel: TeamInviteModel) {
        self.inviteModel = inviteModel
    }
}

class CreateInviteDtoModel: Codable {
    let teamId: UUID
    let email: String
    
    init(teamId: UUID, emailAddressToInvite: String) {
        self.teamId = teamId
        self.email = emailAddressToInvite
    }
}

class TeamInvitesGetByTeamIdReturnModel: Codable {
    let teamInvites: [TeamInviteModel]
    let message: String
}
