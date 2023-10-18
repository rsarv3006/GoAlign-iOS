//
//  EditAssignedTeamMemberModalVM.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/7/23.
//

import Foundation
import Combine

class EditAssignedTeamMemberModalVM {

    private (set) var requestTableReload = PassthroughSubject<Void, Never>()
    private (set) var requestShowError = PassthroughSubject<Error, Never>()

    private (set) var team: TeamModel?
    private let assignedUserId: UUID?

    private let teamId: UUID

    var teamMembers: [UserModel] {
        return team?.users ?? []
    }

    var indexOfAssignedUser: Int? {
        return team?.users.firstIndex(where: { user in
            user.userId == assignedUserId
        })
    }

    init(teamId: UUID, currentlyAssignedUserId: UUID?) {
        self.teamId = teamId
        self.assignedUserId = currentlyAssignedUserId
    }

    func fetchTeamMembers() {
        Task {
            do {
                let teams = try await TeamService.getTeamsByTeamIds(teamIds: [teamId])
                self.team = teams[0]
                requestTableReload.send(Void())
            } catch {
                requestShowError.send(error)
            }
        }
    }
}
