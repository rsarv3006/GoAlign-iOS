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
    private(set) var deleteAccountReturnToSignIn = PassthroughSubject<Bool, Never>()
    
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
                print("DON'T DELETE MY ACCOUNT")
            }
            
            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                self.deleteAccount()
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            self.requestDisplayUIAlert.send(alert)
            
        }
    }
    
    func deleteAccount() {
        UserService.deleteCurrentUser { didSucceed, error in
            self.deleteAccountReturnToSignIn.send(true)
        }
    }
}
