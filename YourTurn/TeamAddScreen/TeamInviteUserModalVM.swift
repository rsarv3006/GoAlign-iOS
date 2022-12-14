//
//  TeamInviteUserModalVM.swift
//  YourTurn
//
//  Created by rjs on 9/10/22.
//

import Foundation
import Combine

class TeamInviteUserModalVM {
    
    let modalTitleText = "Invite People to your Team"
    let closeModalButtonText = "Finish"
    
    var addedInvitedUserSubject = PassthroughSubject<Result<Bool, Error>, Never>()
    
    let teamId: String
    var invitedUsers: [String] = []
    
    init(teamId: String) {
        self.teamId = teamId
    }
    
    func createTeamInvite(emailAddressToInvite: String) {
        let createInvite = CreateInviteDtoModel(teamId: teamId, emailAddressToInvite: emailAddressToInvite)
        TeamInviteService.createInvite(createInviteDto: createInvite) { status, error in
            if status == .success {
                self.invitedUsers.append(emailAddressToInvite)
                self.addedInvitedUserSubject.send(.success(true))
            } else if let error = error {
                self.addedInvitedUserSubject.send(.failure(error))
            } else {
                self.addedInvitedUserSubject.send(.failure(ServiceErrors.custom(message: "Unknown error inviting user. Please try again")))
            }
        }
    }
}
