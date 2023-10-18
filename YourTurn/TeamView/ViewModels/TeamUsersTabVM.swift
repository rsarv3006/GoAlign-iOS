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
    var shouldShowCreateInviteButton = CurrentValueSubject<Bool, Never>(false)
    var requestTableReload = PassthroughSubject<Void, Never>()

    private(set) var canUserEditTeam: Bool = false

    private(set) var team: TeamModel
    var users: [UserModel] {
        return team.users
    }

    init(team: TeamModel) {
        self.team = team
        setDoesUserHaveTeamEdit()
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

    private func setDoesUserHaveTeamEdit() {
        Task {
            let isUserTeamManager = try? await UserService.isUserTeamManager(forTeam: team)
            if isUserTeamManager == true {
                canUserEditTeam = true
                shouldShowCreateInviteButton.send(true)
            }
        }
    }

    func initiateDeleteUserFlow(viewController: TeamUsersTabView, index: Int, type: SelectedList) {
        let (id, userDescriptionString) = getInformationOnObjectToDelete(index: index, type: type)

        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Remove User",
                message: "Are you sure you want to delete \(String(describing: userDescriptionString))?",
                preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }

            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
                alert.removeFromParent()
                viewController.showLoader(true)

                switch type {
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

    private func getInformationOnObjectToDelete(index: Int, type: SelectedList) -> (UUID?, String?) {
        if type == .users {
            return (team.users[index].userId, team.users[index].username)
        } else {
            let teamInvitesResult = teamInvitesSubject.value

            switch teamInvitesResult {
            case .success(let teamInvites):
                let invite = teamInvites[index]
                return (invite.teamInviteId, invite.email)
            default:
                return (nil, nil)
            }
        }
    }

    private func deleteUserFromTeam(viewController: TeamUsersTabView, userId: UUID?) {
        Task {
            do {
                guard let userId else { throw ServiceErrors.custom(message: "UserId is not defined")}
                try await TeamService.removeUserFromTeam(teamId: team.teamId, userToRemove: userId)

                let teams = try await TeamService.getTeamsByTeamIds(teamIds: [team.teamId])
                team = teams[0]
                await viewController.showLoader(false)
                requestTableReload.send(Void())
            } catch {
                await viewController.showLoader(false)
                await viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }

    private func deleteUserInvite(viewController: TeamUsersTabView, inviteId: UUID?) {
        Task {
            do {
                guard let inviteId else { throw ServiceErrors.custom(message: "inviteId is not defined")}
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
