//
//  TeamUsersTabVM.swift
//  YourTurn
//
//  Created by rjs on 11/8/22.
//

import UIKit
import Combine

class TeamUsersTabVM {
    
    var teamInvitesSubject = CurrentValueSubject<Result<[TeamInviteModel], Error>, Never>(.success([]))
    var usersSubject = CurrentValueSubject<[UserModel], Never>([])
    var requestTableReload = PassthroughSubject<Void, Never>()
    
    private(set) var canUserEditTeam: Bool = false
    
    let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
        usersSubject.send(team.teamMembers)
        setCanUserEditTeam()
    }
    
    func fetchTeamInvites() {
        Task {
            do {
                let teamInvites = try await TeamInviteService.getOutstandingInvitesByTeamId(teamId: team.teamId)
                teamInvitesSubject.send(.success(teamInvites))
            } catch {
                teamInvitesSubject.send(.failure(error))
            }
        }
    }
    
    private func setCanUserEditTeam() {
        Task {
            let isUserTeamManager = try? await UserService.isUserTeamManager(forTeam: team)
            if isUserTeamManager == true {
                canUserEditTeam = true
            }
        }
    }
    
    func initiateDeleteUserFlow(viewController: TeamUsersTabView, index: Int, type: SelectedList) {
        let (id, userDescriptionString) = getInformationOnObjectToDelete(index: index, type: type)
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Remove User", message: "Are you sure you want to delete \(userDescriptionString)?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
                alert.removeFromParent()
                viewController.showLoader(true)
                
                switch (type) {
                case .invites:
                    self.deleteUserInvite(viewController: viewController, inviteId: id)
                case .users:
                    self.deleteUserFromTeam(viewController: viewController, userId: id)
                }
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            viewController.present(alert, animated: true)
        }
    }
    
    private func getInformationOnObjectToDelete(index: Int, type: SelectedList) -> (String, String) {
        if type == .users {
            return (team.teamMembers[index].userId, team.teamMembers[index].username)
        } else {
            let teamInvitesResult = teamInvitesSubject.value
            
            switch teamInvitesResult {
            case .success(let teamInvites):
                let invite = teamInvites[index]
                return (invite.inviteId, invite.emailAddressToInvite)
            default:
                return ("", "")
            }
        }
    }
    
    private func deleteUserFromTeam(viewController: TeamUsersTabView, userId: String) {
        Task {
            do {
                try await TeamService.removeUserFromTeam(teamId: team.teamId, userToRemove: userId)
                let teams = try await TeamService.getTeamsByTeamIds(teamIds: [team.teamId])
                usersSubject.send(teams[0].teamMembers)
                await viewController.showLoader(false)
                requestTableReload.send(Void())
            } catch {
                await viewController.showLoader(false)
                await viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }
    
    private func deleteUserInvite(viewController: TeamUsersTabView, inviteId: String) {
        Task {
            do {
                try await TeamInviteService.deleteTeamInvite(inviteId: inviteId)
                
                let teamInvites = try await TeamInviteService.getOutstandingInvitesByTeamId(teamId: team.teamId)
                teamInvitesSubject.send(.success(teamInvites))
                await viewController.showLoader(false)
                requestTableReload.send(Void())
            } catch {
                await viewController.showLoader(false)
                teamInvitesSubject.send(.failure(error))
            }
        }
    }
}
