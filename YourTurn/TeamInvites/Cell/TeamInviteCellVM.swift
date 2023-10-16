//
//  TeamInviteCellVM.swift
//  YourTurn
//
//  Created by rjs on 8/29/22.
//

import Foundation

struct TeamInviteCellVM {
    let teamNameLabel: String
    let invitedByLabel: String

    init(teamName: String, inviterName: String) {
        self.teamNameLabel = teamName
        self.invitedByLabel = "invited by \(inviterName)"
    }
}
