//
//  EditAssignedTeamMemberModal.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/7/23.
//

import UIKit
import Combine

class EditAssignedTeamMemberModal: ModalViewController {
    private var subscriptions = Set<AnyCancellable>()

    var viewModel: EditAssignedTeamMemberModalVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.requestTableReload.sink { _ in
                DispatchQueue.main.async {
                    self.teamMembersTableView.reloadData()
                    if let indexOfAssignedUser = viewModel.indexOfAssignedUser {
                        let indexPath = IndexPath(row: indexOfAssignedUser, section: 0)
                        self.teamMembersTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                        self.tableView(self.teamMembersTableView, didSelectRowAt: indexPath)
                    }
                }
            }.store(in: &subscriptions)

            viewModel.requestShowError.sink { error in
                self.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            }.store(in: &subscriptions)
        }
    }

    // MARK: - UI Elements    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Assigned Team Member"
        return title
    }()

    private lazy var teamMembersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray3
        return tableView
    }()

    private lazy var closeButton: StandardButton = {
        let button = StandardButton()
        button.setTitle("CLOSE", for: .normal)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModal()
        configureTableView()

        viewModel?.fetchTeamMembers()
    }

    // MARK: - Helpers
    func configureModal() {
        view.addSubview(subView)
        subView.center(inView: view)

        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width

        subView.setWidth(screenWidth * 0.75)
        subView.setHeight(screenHeight * 0.6)

        subView.addSubview(titleLabel)
        titleLabel.centerX(inView: subView, topAnchor: subView.topAnchor, paddingTop: 8)

        subView.addSubview(closeButton)
        closeButton.centerX(inView: subView)
        closeButton.anchor(
            left: subView.leftAnchor,
            bottom: subView.bottomAnchor,
            right: subView.rightAnchor,
            paddingLeft: 12,
            paddingBottom: 12,
            paddingRight: 12)
        closeButton.addTarget(self, action: #selector(onClosePressed), for: .touchUpInside)

        subView.addSubview(teamMembersTableView)
        teamMembersTableView.anchor(
            top: titleLabel.bottomAnchor,
            left: subView.leftAnchor,
            bottom: closeButton.topAnchor,
            right: subView.rightAnchor)
    }

    func configureTableView() {
        teamMembersTableView.delegate = self
        teamMembersTableView.dataSource = self
        teamMembersTableView.rowHeight = 40
        teamMembersTableView.register(TeamSelectModalCellView.self, forCellReuseIdentifier: "otherThing")
    }

    @objc func onClosePressed() {
        self.dismiss(animated: true)
    }
}

extension EditAssignedTeamMemberModal: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let team = viewModel?.team {
            let returnValue = TeamSelectModalReturnModel(team: team, teamMember: team.users[indexPath.row])
            delegate?.modalSentValue(viewController: self, value: returnValue)
        }
    }
}

extension EditAssignedTeamMemberModal: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.teamMembers.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherThing", for: indexPath)

        if let teamSelectCell = cell as? TeamSelectModalCellView,
           let teamMembersArray = viewModel?.teamMembers {
            teamSelectCell.nameLabelString = teamMembersArray[indexPath.row].username
            return teamSelectCell
        }

        return cell
    }
}
