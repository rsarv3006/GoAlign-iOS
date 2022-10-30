//
//  TeamInviteUserModal.swift
//  YourTurn
//
//  Created by rjs on 9/10/22.
//

import UIKit
import Combine

private let INVITED_TEAM_MEMBER_CELL_ID = "INVITED_TEAM_MEMBER_CELL_ID"

class TeamInviteUserModal: UIViewController {
    private(set) var subscriptions = Set<AnyCancellable>()
    
    var viewModel: TeamInviteUserModalVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            modalTitle.text = viewModel.modalTitleText
            closeModalButton.setTitle(viewModel.closeModalButtonText, for: .normal)
            
            viewModel.addedInvitedUserSubject.sink { completion in
                print("TeamInviteUserModel - addedInvitedUserSubject - completion")
                print(completion)
            } receiveValue: { _ in
                DispatchQueue.main.async {
                    self.invitedTeamMembersTableView.reloadData()
                    self.emailAddressToInvite.text = ""
                }
            }.store(in: &subscriptions)
        }
    }
    
    // Mark: UI Elements
    private lazy var subView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .systemGray4
        subView.layer.cornerRadius = 10
        return subView
    }()
    
    private lazy var modalTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var errorLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.systemRed
        lbl.text = ""
        return lbl
    }()
    
    private lazy var emailAddressToInvite: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .roundedRect
        txtField.backgroundColor = .clear
        txtField.delegate = self
        txtField.layer.borderColor = UIColor.systemGray5.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        return txtField
    }()
    
    private lazy var invitedTeamMembersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray4
        return tableView
    }()
    
    private lazy var inviteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        return button
    }()
    
    private lazy var closeModalButton: StandardButton = {
        let button = StandardButton()
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModal()
        configureInteractables()
    }
    
    // MARK: Helpers
    func configureModal() {
        invitedTeamMembersTableView.register(UITableViewCell.self, forCellReuseIdentifier: INVITED_TEAM_MEMBER_CELL_ID)
        invitedTeamMembersTableView.rowHeight = 44
        invitedTeamMembersTableView.dataSource = self
        invitedTeamMembersTableView.delegate = self
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(subView)
        subView.center(inView: view)
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        let subViewWidth = screenWidth * 0.75
        let subViewHeight = screenHeight * 0.6
        subView.setWidth(subViewWidth)
        subView.setHeight(subViewHeight)
        
        subView.addSubview(modalTitle)
        modalTitle.centerX(inView: subView)
        modalTitle.anchor(top: subView.topAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 44)
        
        subView.addSubview(emailAddressToInvite)
        emailAddressToInvite.anchor(top: modalTitle.bottomAnchor, left: subView.leftAnchor, paddingLeft: 16, width: subViewWidth * 0.9, height: 32)
        
        subView.addSubview(inviteButton)
        inviteButton.anchor(top: modalTitle.bottomAnchor, left: emailAddressToInvite.rightAnchor, right: subView.rightAnchor, paddingRight: 12, width: subViewWidth * 0.1, height: 32)
        
        subView.addSubview(closeModalButton)
        closeModalButton.anchor(left: subView.leftAnchor, bottom: subView.bottomAnchor, right: subView.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 44)
        
        subView.addSubview(invitedTeamMembersTableView)
        invitedTeamMembersTableView.anchor(top: emailAddressToInvite.bottomAnchor, left: subView.leftAnchor, bottom: closeModalButton.topAnchor, right: subView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
    }
    
    func configureInteractables() {
        inviteButton.addTarget(self, action: #selector(onInviteButtonPressed), for: .touchUpInside)
        closeModalButton.addTarget(self, action: #selector(onCloseModalButtonPressed), for: .touchUpInside)
    }
    
    @objc func onInviteButtonPressed() {
        guard let emailAddressToInviteText = emailAddressToInvite.text else { return }
        viewModel?.createTeamInvite(emailAddressToInvite: emailAddressToInviteText)
    }
    
    @objc func onCloseModalButtonPressed() {
        self.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension TeamInviteUserModal: UITextFieldDelegate {}

// MARK: - UITableViewDelegate
extension TeamInviteUserModal: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension TeamInviteUserModal: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.invitedUsers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: INVITED_TEAM_MEMBER_CELL_ID, for: indexPath)
        cell.textLabel?.text = viewModel?.invitedUsers[indexPath.row] ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
