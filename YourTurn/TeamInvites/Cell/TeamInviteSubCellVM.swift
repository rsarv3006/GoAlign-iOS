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
    
    let inviteId: String
    
    init(inviteId: String) {
        self.inviteId = inviteId
    }
    
    private(set) var requestReloadSubject = PassthroughSubject<Bool, Never>()
    
    private(set) var requestDisplayUIAlert = PassthroughSubject<UIAlertController, Never>()
    
    func acceptInvite(delegate: TeamInvitesViewControllerDelegate?) {
        delegate?.modifyLoaderState(shouldShowLoader: true)
        TeamInviteService.acceptInvite(inviteId: inviteId) { status, error in
            delegate?.modifyLoaderState(shouldShowLoader: false)
            if status == .success {
                requestReloadSubject.send(true)
            } else if let error = error {
                displayUIAlert(error: error)
            } else {
                displayUIAlert(error: ServiceErrors.custom(message: "Unknown error accepting invite"))
            }
        }
    }
    
    func declineInvite(delegate: TeamInvitesViewControllerDelegate?) {
        delegate?.modifyLoaderState(shouldShowLoader: true)
        TeamInviteService.declineInvite(inviteId: inviteId) { status, error in
            delegate?.modifyLoaderState(shouldShowLoader: false)
            if status == .success {
                requestReloadSubject.send(true)
            } else if let error = error {
                displayUIAlert(error: error)
            } else {
                displayUIAlert(error: ServiceErrors.custom(message: "Unknown error declining invite"))
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
