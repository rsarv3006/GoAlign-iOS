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
    
    var teamInvitesSubject = PassthroughSubject<Result<[TeamInviteDisplayModel], Error>, Never>()
    
    func fetchCurrentInvites() {
        Task {
            do {
                let teamInvites = try await TeamInviteService.getTeamInvitesByCurrentUser()
                let teamInvitesDisplayModels: [TeamInviteDisplayModel] = teamInvites.compactMap { teamInvite in
                    return TeamInviteDisplayModel(inviteModel: teamInvite)
                }
                teamInvitesSubject.send(.success(teamInvitesDisplayModels))
            } catch {
                Logger.log(logLevel: .Verbose, name: Logger.Events.Team.Invite.fetchFailed, payload: ["error": error.localizedDescription])
                teamInvitesSubject.send(.failure(error))
            }
        }
    }
}
