//
//  TeamSettingsDeleteTeamCellVM.swift
//  YourTurn
//
//  Created by rjs on 12/23/22.
//

import UIKit

class TeamSettingsDeleteTeamCellVM {
    let deleteTeamButtonTitle: String = "Delete Team"
    private let team: TeamModel

    var delegate: TeamSettingsCellsDelegate?

    init(team: TeamModel) {
        self.team = team
    }

    func displayConfirmDeleteTeamModal() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Delete Team", message: "Are you sure you want to delete this team?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }

            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                self.deleteTeam()
                Logger.log(logLevel: .Prod, name: Logger.Events.Team.deleteAttempt, payload: ["teamId": self.team.teamId])
            }

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)

            self.delegate?.requestShowAlertFromCell(alert: alert)

        }
    }

    private func deleteTeam() {
        delegate?.requestShowLoaderFromCell(isVisible: true)
        defer {
            delegate?.requestShowLoaderFromCell(isVisible: false)
        }

        Task {
            do {
                try await TeamService.deleteTeam(teamId: team.teamId)
                delegate?.requestHomeReloadFromCell()
                delegate?.requestRemoveTabViewFromCell()
            } catch {
                delegate?.requestShowMessageFromCell(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }
}
