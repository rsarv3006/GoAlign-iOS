//
//  TeamUsersTabVM.swift
//  YourTurn
//
//  Created by rjs on 11/8/22.
//

import Foundation
import Combine

struct TeamUsersTabVM {
    
    var teamInvitesSubject = CurrentValueSubject<[TeamInviteModel], Never>([])
    var usersSubject = CurrentValueSubject<[UserModel], Never>([])
    
    private let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
        usersSubject.send(team.teamMembers)
    }
    
    func fetchTeamInvites() {
        TeamInviteService.getOutstandingInvitesByTeamId(teamId: team.teamId) { teamInvites, error in
            if let teamInvites = teamInvites {
                teamInvitesSubject.send(teamInvites)
            }
        }
    }
}
