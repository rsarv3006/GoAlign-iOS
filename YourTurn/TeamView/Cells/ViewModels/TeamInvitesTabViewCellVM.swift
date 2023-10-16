//
//  TeamInvitesTabViewCellVM.swift
//  YourTurn
//
//  Created by rjs on 11/8/22.
//

import Foundation

struct TeamInvitesTabViewCellVM {

    let inviteeEmail: String

    init(invite: TeamInviteModel) {
        self.inviteeEmail = invite.email
    }
}
