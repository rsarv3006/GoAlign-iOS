//
//  TeamSettingsTabVM.swift
//  YourTurn
//
//  Created by rjs on 12/17/22.
//

import UIKit
import Combine

struct TeamSettingsTabVM {
    var requestHomeReload = PassthroughSubject<Bool, Never>()
    private(set) var requestRemoveTabView = PassthroughSubject<Bool, Never>()
    
    let deleteTeamButtonTitle: String = "Delete Team"
    let leaveTeamButtonTitle: String = "Leave Team"
    
    let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
    }
    
    func onRequestDeleteTeam(viewController: UIViewController) {
        viewController.showLoader(true)
        TeamService.deleteTeam(teamId: team.teamId) { didSucceed, error in
            viewController.showLoader(false)
            if didSucceed == true {
                self.requestHomeReload.send(true)
                self.requestRemoveTabView.send(true)
            } else if let error = error {
                viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            } else {
                viewController.showMessage(withTitle: "Uh Oh", message: "Unexpected error, please try again.")
            }
        }
    }
    
    func onRemoveSelfFromTeam(viewController: UIViewController) {
        viewController.showLoader(true)
        UserService.getCurrentUser { user, error in
            viewController.showLoader(false)
            if let user = user {
                viewController.showLoader(true)
                TeamService.removeUserFromTeam(teamId: team.teamId, userToRemove: user.userId) { didSucceed, error in
                    viewController.showLoader(false)
                    if didSucceed == true {
                        Logger.log(logLevel: .Prod, name: Logger.Events.Team.leaveSuccess, payload: ["teamId": team.teamId, "userId": user.userId])
                        self.requestHomeReload.send(true)
                        self.requestRemoveTabView.send(true)
                    } else if let error = error {
                        viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
                    } else {
                        viewController.showMessage(withTitle: "Uh Oh", message: "Unexpected error, please try again.")
                    }
                }
            } else if let error = error {
                viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            } else {
                viewController.showMessage(withTitle: "Uh Oh", message: "Unexpected error, please try again.")
            }
        }
    }
}
