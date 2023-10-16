//
//  TeamInviteUserModalVM.swift
//  YourTurn
//
//  Created by rjs on 9/10/22.
//

import Foundation
import Combine

class TeamInviteUserModalVM {

    var delegate: TeamUsersReloadDelegate?

    let modalTitleText = "Invite People to your Team"
    let closeModalButtonText = "Finish"

    var addedInvitedUserSubject = PassthroughSubject<Result<Bool, Error>, Never>()

    let teamId: UUID
    var invitedUsers: [String] = []

    init(teamId: UUID) {
        self.teamId = teamId
    }

    func createTeamInvite(emailAddressToInvite: String) {
        let createInvite = CreateInviteDtoModel(teamId: teamId, emailAddressToInvite: emailAddressToInvite)

        Task {
            do {
                let status = try await TeamInviteService.createInvite(createInviteDto: createInvite)
                if status == .success {
                    invitedUsers.append(emailAddressToInvite)
                    addedInvitedUserSubject.send(.success(true))
                }
            } catch {
                self.addedInvitedUserSubject.send(.failure(error))
            }
        }
    }
}
