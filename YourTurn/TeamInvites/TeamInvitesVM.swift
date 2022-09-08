//
//  TeamInvitesVM.swift
//  YourTurn
//
//  Created by rjs on 8/29/22.
//

import Foundation
import Combine

class TeamInvitesVM {
    private var subscriptions = Set<AnyCancellable>()
    
    var teamInvitesSubject = PassthroughSubject<[TeamInviteDisplayModel], Error>()
    
    func fetchCurrentInvites() {
        TeamInviteService.getTeamInvitesByCurrentUser { teamInvites, error in
            if let error = error {
                self.teamInvitesSubject.send(completion: .failure(error))
            } else if let teamInvites = teamInvites {
                let teamInvitesDisplayModels: [TeamInviteDisplayModel] = teamInvites.compactMap { teamInvite in
                    return TeamInviteDisplayModel(inviteModel: teamInvite)
                }
                self.teamInvitesSubject.send(teamInvitesDisplayModels)
            }
        }
    }
}