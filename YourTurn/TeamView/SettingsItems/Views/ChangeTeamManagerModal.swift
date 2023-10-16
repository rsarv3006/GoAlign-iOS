//
//  ChangeTeamManagerModal.swift
//  YourTurn
//
//  Created by rjs on 12/22/22.
//

import UIKit

private let teamMemberReuseIdentifier = "teamMemberReuseIdentifier"

class ChangeTeamManagerModal: YtViewController {
    var viewModel: ChangeTeamManagerModalVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            configureFromViewModel(viewModel: viewModel)
            membersTableView.reloadData()
        }
    }

    private lazy var modalView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .systemGray4
        subView.layer.cornerRadius = 10
        return subView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var membersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .customBackgroundColor
        return tableView
    }()

    private lazy var confirmButton: BlueButton = {
        let button = BlueButton()
        button.isEnabled = false
        return button
    }()

    private lazy var cancelButton: AlertButton = {
        let button = AlertButton()
        return button
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        configureModal()
        super.viewDidLoad()
        configureInteractables()
    }

    // MARK: Helpers
    override func configureView() {
        let modalWidth = UIScreen.main.bounds.size.width * 0.75

        modalView.backgroundColor = .customBackgroundColor

        modalView.addSubview(titleLabel)
        titleLabel.centerX(inView: modalView, topAnchor: modalView.topAnchor, paddingTop: 8)

        view.addSubview(cancelButton)
        cancelButton.anchor(
            left: modalView.leftAnchor,
            bottom: modalView.bottomAnchor,
            paddingTop: 12,
            paddingLeft: 12,
            paddingBottom: 8,
            paddingRight: 12,
            width: modalWidth / 2 - 12)

        view.addSubview(confirmButton)
        confirmButton.anchor(
            left: cancelButton.rightAnchor,
            bottom: modalView.bottomAnchor,
            right: modalView.rightAnchor,
            paddingTop: 12,
            paddingLeft: 12,
            paddingBottom: 8,
            paddingRight: 12)

        modalView.addSubview(membersTableView)
        membersTableView.anchor(
            top: titleLabel.bottomAnchor,
            left: modalView.leftAnchor,
            bottom: cancelButton.topAnchor,
            right: modalView.rightAnchor)

        membersTableView.delegate = self
        membersTableView.dataSource = self
        membersTableView.register(ChangeTeamManagerUserCell.self, forCellReuseIdentifier: teamMemberReuseIdentifier)

    }

    private func configureModal() {
        view.addSubview(modalView)
        modalView.center(inView: view)

        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width

        modalView.setWidth(screenWidth * 0.75)
        modalView.setHeight(screenHeight * 0.6)
    }

    private func configureFromViewModel(viewModel: ChangeTeamManagerModalVM) {
        titleLabel.text = viewModel.modalTitleString
        cancelButton.setTitle(viewModel.cancelButtonString, for: .normal)
        confirmButton.setTitle(viewModel.confirmButtonString, for: .normal)
    }

    private func configureInteractables() {
        cancelButton.addTarget(self, action: #selector(onCancelPressed), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(onConfirmPressed), for: .touchUpInside)
    }

    @objc func onCancelPressed() {
        self.dismiss(animated: true)
    }

    @objc func onConfirmPressed() {
        let message = viewModel?.createConfirmChangeAlertString()
        let alert = UIAlertController(title: "Confirm Team Manager Change", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
            alert.removeFromParent()
        }

        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            alert.removeFromParent()
            self.viewModel?.changeTeamManager(viewController: self)
        }

        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ChangeTeamManagerModal: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.teamMembers.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: teamMemberReuseIdentifier, for: indexPath)

        if let changeTeamCell = cell as? ChangeTeamManagerUserCell,
           let teamMember = viewModel?.teamMembers[indexPath.row] {
            changeTeamCell.viewModel = ChangeTeamManagerUserCellVM(teamMember: teamMember)
            return changeTeamCell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectedUser = viewModel?.teamMembers[indexPath.row]
        confirmButton.isEnabled = true
    }
}

// MARK: - UITableViewDelegate
extension ChangeTeamManagerModal: UITableViewDelegate {}
