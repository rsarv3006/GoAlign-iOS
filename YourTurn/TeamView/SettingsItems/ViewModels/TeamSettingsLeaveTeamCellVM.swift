//
//  TeamSettingsRemoveSelfFromTeamCellVM.swift
//  YourTurn
//
//  Created by rjs on 12/23/22.
//

import UIKit

class TeamSettingsLeaveTeamCellVM {
    let leaveTeamButtonTitle: String = "Leave Team"
    let team: TeamModel

    var delegate: TeamSettingsCellsDelegate?

    init(team: TeamModel) {
        self.team = team
    }

    func displayRemoveSelfFromTeamModal() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Leave Team", message: "Are you sure you want to leave this team?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }

            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                self.leaveTeam()
                Logger.log(logLevel: .Prod, name: Logger.Events.Team.leaveAttempt, payload: ["teamId": self.team.teamId])
            }

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)

            self.delegate?.requestShowAlertFromCell(alert: alert)
        }
    }

    private func leaveTeam() {
        delegate?.requestShowLoaderFromCell(isVisible: true)
        defer {
            delegate?.requestShowLoaderFromCell(isVisible: false)
        }

        Task {
            do {
                if let currentUser = AppState.getInstance().currentUser {
                    try await TeamService.removeUserFromTeam(teamId: team.teamId, userToRemove: currentUser.userId)

                    Logger.log(logLevel: .Prod, name: Logger.Events.Team.leaveSuccess, payload: ["teamId": team.teamId, "userId": currentUser.userId])
                    delegate?.requestHomeReloadFromCell()
                    delegate?.requestRemoveTabViewFromCell()
                } else {
                    delegate?.requestShowMessageFromCell(withTitle: "Uh Oh", message: "We couldn't find your user account. Please try logging out and back in.")
                }
            } catch {
                delegate?.requestShowMessageFromCell(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }
}
