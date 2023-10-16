//
//  TeamSelectModal.swift
//  YourTurn
//
//  Created by rjs on 8/16/22.
//

import UIKit

private let TEAM_SELECT = 1020
private let TEAM_MEMBER_SELECT = 1030

class TeamSelectModal: ModalViewController {

    private var teams = [TeamModel]() {
        didSet {
            DispatchQueue.main.async {
                self.teamSelectTableView.reloadData()
                self.teamMemberSelectTableView.reloadData()
            }
        }
    }

    private var selectedTeamIndex: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.teamMemberSelectTableView.reloadData()
            }
        }
    }

    // MARK: - UI Elements
    private lazy var closeButton: BlueButton = {
        let button = BlueButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.customBackgroundColor, for: .normal)
        return button
    }()

    private lazy var teamTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Select the Team"
        label.textColor = .customTitleText
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    private lazy var teamMemberTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Select the Team Member"
        label.textColor = .customTitleText
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    private let teamSelectTableView: UITableView = {
        let tv = UITableView()
        tv.tag = TEAM_SELECT
        tv.backgroundColor = .customBackgroundColor
        return tv
    }()

    private let teamMemberSelectTableView: UITableView = {
        let tv = UITableView()
        tv.tag = TEAM_MEMBER_SELECT
        tv.backgroundColor = .customBackgroundColor
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(true)
        configureModal()
        setupTables()
        configureView()
        loadTeamsAndMembers()
    }

    @objc func onClosePressed() {
        self.dismiss(animated: true)
    }

    func loadTeamsAndMembers() {
        defer {
            self.showLoader(false)
        }
        Task {
            do {
                let teams = try await TeamService.getTeamsByCurrentUser()
                self.teams = teams
            } catch {
                Logger.log(logLevel: .Prod, name: Logger.Events.Team.fetchFailed, payload: ["error": error])
                self.showMessage(withTitle: "Uh Oh", message: "Unexpected error encountered loading teams. \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension TeamSelectModal: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == TEAM_SELECT {
            let returnValue = TeamSelectModalReturnModel(team: teams[indexPath.row], teamMember: teams[indexPath.row].users[0])
            delegate?.modalSentValue(viewController: self, value: returnValue)
            selectedTeamIndex = indexPath.row
        } else if tableView.tag == TEAM_MEMBER_SELECT {
            let returnValue = TeamSelectModalReturnModel(team: teams[selectedTeamIndex], teamMember: teams[selectedTeamIndex].users[indexPath.row])
            delegate?.modalSentValue(viewController: self, value: returnValue)
        }
    }
}

// MARK: - UITableViewDataSource
extension TeamSelectModal: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == TEAM_SELECT {
            return teams.count
        } else if tableView.tag == TEAM_MEMBER_SELECT {
            if teams.count > 0 {
                return teams[selectedTeamIndex].users.count
            } else {
                return 0
            }

        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == TEAM_SELECT {
            let cell = tableView.dequeueReusableCell(withIdentifier: "thing", for: indexPath) as! TeamSelectModalCellView
            cell.nameLabelString = teams[indexPath.row].teamName
            return cell
        } else if tableView.tag == TEAM_MEMBER_SELECT {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherThing", for: indexPath) as! TeamSelectModalCellView
            cell.nameLabelString = teams[selectedTeamIndex].users[indexPath.row].username
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "crash baby")
        }
    }
}

extension TeamSelectModal {
    func configureView() {
        subView.backgroundColor = .customBackgroundColor
        subView.addSubview(closeButton)
        closeButton.centerX(inView: subView)
        closeButton.anchor(left: subView.leftAnchor, bottom: subView.bottomAnchor, right: subView.rightAnchor, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)

        closeButton.addTarget(self, action: #selector(onClosePressed), for: .touchUpInside)

        subView.addSubview(teamTitleLabel)
        teamTitleLabel.centerX(inView: subView)
        teamTitleLabel.anchor(top: subView.topAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 44)

        teamSelectTableView.register(TeamSelectModalCellView.self, forCellReuseIdentifier: "thing")
        teamMemberSelectTableView.register(TeamSelectModalCellView.self, forCellReuseIdentifier: "otherThing")

        subView.addSubview(teamSelectTableView)
        teamSelectTableView.anchor(top: teamTitleLabel.bottomAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 120)

        subView.addSubview(teamMemberTitleLabel)
        teamMemberTitleLabel.centerX(inView: subView)
        teamMemberTitleLabel.anchor(top: teamSelectTableView.bottomAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 44)

        subView.addSubview(teamMemberSelectTableView)
        teamMemberSelectTableView.anchor(top: teamMemberTitleLabel.bottomAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 120)
    }

    func setupTables() {
        teamSelectTableView.delegate = self
        teamSelectTableView.dataSource = self
        teamSelectTableView.rowHeight = 40

        teamMemberSelectTableView.delegate = self
        teamMemberSelectTableView.dataSource = self
        teamMemberSelectTableView.rowHeight = 40
    }

    func configureModal() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        view.addSubview(subView)
        subView.center(inView: view)

        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width

        subView.setWidth(screenWidth * 0.75)
        subView.setHeight(screenHeight * 0.6)
    }
}
