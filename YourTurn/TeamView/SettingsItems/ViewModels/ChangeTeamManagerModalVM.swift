//
//  ChangeTeamManagerModalVM.swift
//  YourTurn
//
//  Created by rjs on 12/22/22.
//

import UIKit
import Combine

class ChangeTeamManagerModalVM {
    private(set) var requestReload = PassthroughSubject<Void, Never>()

    let modalTitleString = "Change Team Manager"
    let confirmButtonString = "Confirm"
    let cancelButtonString = "Cancel"

    private let team: TeamModel

    var teamMembers: [UserModel] {
        return team.users
    }

    var selectedUser: UserModel?

    init(team: TeamModel) {
        self.team = team
    }

    func createConfirmChangeAlertString() -> String {
        guard let selectedUser = selectedUser else { return ""}
        return "Are you sure you want to give control of the \(team.teamName) to \(selectedUser.username)?"
    }

    func changeTeamManager(viewController: UIViewController) {
        viewController.showLoader(true)
        defer {
            viewController.showLoader(false)
        }
        Task {
            do {
                guard let newManagerId = selectedUser?.userId else {
                    throw ServiceErrors.custom(message: "Unexpected error encountered, user not selected.")
                }
                try await TeamService.updateTeamManager(teamId: team.teamId, newManagerId: newManagerId)
                await viewController.dismiss(animated: true)
                requestReload.send(Void())
            } catch {
                await viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }
}
