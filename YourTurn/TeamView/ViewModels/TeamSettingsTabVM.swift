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
    
    private let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
    }
    
    func displayConfirmDeleteTeamModal(viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Delete Team", message: "Are you sure you want to delete this team?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }
            
            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                deleteTeam(viewController: viewController)
                Logger.log(logLevel: .Prod, name: Logger.Events.Team.deleteAttempt, payload: ["teamId":team.teamId])
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            viewController.present(alert, animated: true)
            
        }
    }
    
    private func deleteTeam(viewController: UIViewController) {
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
    
    func displayRemoveSelfFromTeamModal(viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Leave Team", message: "Are you sure you want to leave this team?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }
            
            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                leaveTeam(viewController: viewController)
                Logger.log(logLevel: .Prod, name: Logger.Events.Team.leaveAttempt, payload: ["teamId":team.teamId])
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            viewController.present(alert, animated: true)
            
        }
    }
    
    private func leaveTeam(viewController: UIViewController) {
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
