//
//  DeleteUserCell.swift
//  YourTurn
//
//  Created by rjs on 9/15/22.
//

import UIKit
import Combine

class DeleteUserCell: UITableViewCell {
    let id: SettingsVariant = .DeleteUser
    
    private(set) var requestDisplayUIAlert = PassthroughSubject<UIAlertController, Never>()
    private(set) var deleteAccountReturnToSignIn = PassthroughSubject<Result<Bool, Error>, Never>()
    
    // MARK: UI Elements
    private lazy var deleteUserButton: AlertButton = {
        let button = AlertButton()
        button.setTitle("Delete Account", for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureInteractables()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    func configureView() {
        contentView.backgroundColor = .customBackgroundColor
        
        contentView.addSubview(deleteUserButton)
        deleteUserButton.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 2, paddingRight: 8)
    }
    
    func configureInteractables() {
        deleteUserButton.addTarget(self, action: #selector(onDeleteUserButton), for: .touchUpInside)
    }
    
    @objc func onDeleteUserButton() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }
            
            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                self.deleteAccount()
                Logger.log(logLevel: .Prod, name: Logger.Events.User.deleteAttempt, payload: [:])
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            self.requestDisplayUIAlert.send(alert)
            
        }
    }
    
    func deleteAccount() {
        Task {
            do {
                let deleteResult = try await UserService.deleteCurrentUser()
                if deleteResult == true {
                    self.deleteAccountReturnToSignIn.send(.success(true))
                } else {
                    throw ServiceErrors.custom(message: "Failed to delete account. Please try again and contact support if the issue persists.")
                }
            } catch {
                self.deleteAccountReturnToSignIn.send(.failure(error))
            }
        }
    }
}
