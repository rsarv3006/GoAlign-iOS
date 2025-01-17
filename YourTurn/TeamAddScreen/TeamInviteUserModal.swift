//
//  TeamInviteUserModal.swift
//  YourTurn
//
//  Created by rjs on 9/10/22.
//

import UIKit
import Combine

private let INVITEDTEAMMEMBERCELLID = "INVITED_TEAM_MEMBER_CELL_ID"

class TeamInviteUserModal: YtViewController {
    private(set) var subscriptions = Set<AnyCancellable>()

    var viewModel: TeamInviteUserModalVM? {
        didSet {
            guard let viewModel = viewModel else { return }

            modalTitle.text = viewModel.modalTitleText
            closeModalButton.setTitle(viewModel.closeModalButtonText, for: .normal)

            viewModel.addedInvitedUserSubject.sink { inviteResponse in
                DispatchQueue.main.async {
                    self.showLoader(false)
                    switch inviteResponse {
                    case .failure(let error):
                        self.showMessage(
                            withTitle: "Uh Oh",
                            message: "Unexpected error encountered. \(error.localizedDescription)")
                    case .success:
                        self.showLoader(false)
                        self.invitedTeamMembersTableView.reloadData()
                        self.emailAddressToInvite.text = ""
                    }
                }
            }.store(in: &subscriptions)
        }
    }

    // MARK: UI Elements
    private lazy var subView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .customBackgroundColor
        subView.layer.cornerRadius = 10
        return subView
    }()

    private lazy var modalTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .customTitleText
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
        tableView.backgroundColor = .customBackgroundColor
        return tableView
    }()

    private lazy var inviteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        return button
    }()

    private lazy var closeModalButton: StandardButton = {
        let button = StandardButton()
        button.backgroundColor = .customAccentColor
        button.setTitleColor(.customBackgroundColor, for: .normal)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModal()
        configureInteractables()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onTextDidChange),
            name: UITextField.textDidChangeNotification,
            object: nil)
    }

    // MARK: Helpers
    // swiftlint:disable:next function_body_length
    func configureModal() {
        invitedTeamMembersTableView.register(UITableViewCell.self, forCellReuseIdentifier: INVITEDTEAMMEMBERCELLID)
        invitedTeamMembersTableView.rowHeight = 44
        invitedTeamMembersTableView.dataSource = self
        invitedTeamMembersTableView.delegate = self

        view.addSubview(subView)
        subView.center(inView: view)

        subView.setWidth(310)
        subView.setHeight(442)

        subView.addSubview(modalTitle)
        modalTitle.centerX(inView: subView)
        modalTitle.anchor(top: subView.topAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 44)

        subView.addSubview(emailAddressToInvite)
        emailAddressToInvite.anchor(
            top: modalTitle.bottomAnchor,
            left: subView.leftAnchor,
            paddingLeft: 16,
            width: 280,
            height: 32)

        subView.addSubview(inviteButton)
        inviteButton.anchor(
            top: modalTitle.bottomAnchor,
            left: emailAddressToInvite.rightAnchor,
            right: subView.rightAnchor,
            paddingRight: 12,
            width: 32,
            height: 32)

        subView.addSubview(errorLbl)
        errorLbl.anchor(
            top: inviteButton.bottomAnchor,
            left: subView.leftAnchor,
            right: subView.rightAnchor,
            paddingLeft: 16,
            paddingRight: 16,
            height: 24)

        subView.addSubview(closeModalButton)
        closeModalButton.anchor(
            left: subView.leftAnchor,
            bottom: subView.bottomAnchor,
            right: subView.rightAnchor,
            paddingLeft: 16,
            paddingBottom: 8,
            paddingRight: 16,
            height: 44)

        subView.addSubview(invitedTeamMembersTableView)
        invitedTeamMembersTableView.anchor(
            top: errorLbl.bottomAnchor,
            left: subView.leftAnchor,
            bottom: closeModalButton.topAnchor,
            right: subView.rightAnchor,
            paddingTop: 12,
            paddingLeft: 16,
            paddingBottom: 8,
            paddingRight: 16)

    }

    func configureInteractables() {
        inviteButton.addTarget(self, action: #selector(onInviteButtonPressed), for: .touchUpInside)
        closeModalButton.addTarget(self, action: #selector(onCloseModalButtonPressed), for: .touchUpInside)
    }

    @objc func onInviteButtonPressed() {
        if let emailAddressToInviteText = emailAddressToInvite.text,
            emailAddressToInviteText.count > 0,
            emailAddressToInviteText.contains("@") {
            showLoader(true)
            viewModel?.createTeamInvite(emailAddressToInvite: emailAddressToInviteText)
        } else {
            errorLbl.text = "Email not valid"
        }
    }

    @objc func onCloseModalButtonPressed() {
        if let count = viewModel?.invitedUsers.count, count > 0 {
            self.dismiss(animated: true)
            viewModel?.delegate?.requestInvitesReload()
        } else {
            confirmCloseModal()
        }
    }

    private func confirmCloseModal() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Confirm",
                message: "No users have been invited, are you sure you want to leave?",
                preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }

            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                self.dismiss(animated: true)
                self.viewModel?.delegate?.requestInvitesReload()
            }

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)

            self.present(alert, animated: true)

        }
    }
    @objc func onTextDidChange() {
        errorLbl.text = ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: INVITEDTEAMMEMBERCELLID, for: indexPath)
        cell.backgroundColor = .customBackgroundColor
        cell.textLabel?.text = viewModel?.invitedUsers[indexPath.row] ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
