//
//  TeamInvitesViewController.swift
//  YourTurn
//
//  Created by rjs on 8/28/22.
//

import UIKit
import Combine

private let TEAM_INVITE_CELL_REUSE_ID = "teamInviteCell"
private let TEAM_INVITE_SUB_CELL_REUSE_ID = "teamInviteSubCell"



class TeamInvitesViewController: UITableViewController {
    var subscriptions = Set<AnyCancellable>()
    
    var viewModel: TeamInvitesVM? {
        didSet {
            viewModel?.fetchCurrentInvites()
            configureCombineListeners()
        }
    }
    
    private lazy var teamInvites: [TeamInviteDisplayModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Team Invites"
        
        tableView.register(TeamInviteCellView.self, forCellReuseIdentifier: TEAM_INVITE_CELL_REUSE_ID)
        tableView.register(TeamInviteSubCellView.self, forCellReuseIdentifier: TEAM_INVITE_SUB_CELL_REUSE_ID)
        tableView.rowHeight = 60
    }

    // MARK: - Helpers
    func configureCombineListeners() {
        viewModel?.teamInvitesSubject.sink(receiveCompletion: { completion in
            // TODO: - Handle completion and errors
        }, receiveValue: { teamInvites in
            self.teamInvites = teamInvites
        }).store(in: &subscriptions)
    }
}

extension TeamInvitesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if teamInvites[section].areButtonsVisible {
            return 2
        } else {
            return 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return teamInvites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TEAM_INVITE_CELL_REUSE_ID, for: indexPath) as! TeamInviteCellView
            let invite = teamInvites[indexPath.section].inviteModel
            cell.viewModel = TeamInviteCellVM(teamName: invite.team.teamName, inviterName: "FIX THIS")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TEAM_INVITE_SUB_CELL_REUSE_ID, for: indexPath) as! TeamInviteSubCellView
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            teamInvites[indexPath.section].areButtonsVisible = !teamInvites[indexPath.section].areButtonsVisible
            tableView.reloadData()
        }

        return nil
    }
}
