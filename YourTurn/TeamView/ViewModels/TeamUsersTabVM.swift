//
//  TeamUsersTabVM.swift
//  YourTurn
//
//  Created by rjs on 11/8/22.
//

import UIKit
import Combine

struct TeamUsersTabVM {
    
    var teamInvitesSubject = CurrentValueSubject<Result<[TeamInviteModel], Error>, Never>(.success([]))
    var usersSubject = CurrentValueSubject<[UserModel], Never>([])
    
    let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
        usersSubject.send(team.teamMembers)
    }
    
    func fetchTeamInvites() {
        TeamInviteService.getOutstandingInvitesByTeamId(teamId: team.teamId) { teamInvites, error in
            if let teamInvites = teamInvites {
                teamInvitesSubject.send(.success(teamInvites))
            } else if let error = error {
                teamInvitesSubject.send(.failure(error))
            }
        }
    }
}
