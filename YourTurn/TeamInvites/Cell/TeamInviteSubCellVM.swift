//
//  TeamInviteSubCellVM.swift
//  YourTurn
//
//  Created by rjs on 9/5/22.
//

import UIKit
import Combine

struct TeamInviteSubCellVM {
    let acceptButtonLabel: String = "Accept"
    let declineButtonLabel: String = "Decline"

    let inviteId: UUID

    init(inviteId: UUID) {
        self.inviteId = inviteId
    }

    private(set) var requestReloadSubject = PassthroughSubject<Bool, Never>()

    private(set) var requestDisplayUIAlert = PassthroughSubject<UIAlertController, Never>()

    func acceptInvite(delegate: TeamInvitesViewControllerDelegate?) {
        delegate?.modifyLoaderState(shouldShowLoader: true)
        defer {
            delegate?.modifyLoaderState(shouldShowLoader: false)
        }
        Task {
            do {
                let status = try await TeamInviteService.acceptInvite(inviteId: inviteId)
                if status == .success {
                    requestReloadSubject.send(true)
                }
            } catch {
                Logger.log(
                    logLevel: .verbose,
                    name: Logger.Events.Team.Invite.acceptFailed,
                    payload: ["error": error.localizedDescription])
                displayUIAlert(error: error)
            }
        }
    }

    func declineInvite(delegate: TeamInvitesViewControllerDelegate?) {
        delegate?.modifyLoaderState(shouldShowLoader: true)
        defer {
            delegate?.modifyLoaderState(shouldShowLoader: false)
        }

        Task {
            do {
                let status = try await TeamInviteService.declineInvite(inviteId: inviteId)
                if status == .success {
                    requestReloadSubject.send(true)
                }
            } catch {
                Logger.log(
                    logLevel: .verbose,
                    name: Logger.Events.Team.Invite.declineFailed,
                    payload: ["error": error.localizedDescription])
                displayUIAlert(error: error)
            }
        }
    }

    private func displayUIAlert(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Uh Oh", message: error.localizedDescription, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Close", style: .default) { _ in
                alert.removeFromParent()
            }
            alert.addAction(alertAction)

            requestDisplayUIAlert.send(alert)
        }
    }
}
