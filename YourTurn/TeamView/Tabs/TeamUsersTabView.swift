//
//  GroupUsersTabView.swift
//  YourTurn
//
//  Created by rjs on 11/6/22.
//

import UIKit
import Combine

enum SelectedList {
    case users
    case invites
}

private struct TabCellIdentifiers {
    static let users = "TeamUsersTabTableCellIdentifiersUsers"
    static let invites = "TeamUsersTabTableCellIdentifiersInvites"
}

class TeamUsersTabView: YtViewController {
    
    var subscriptions = Set<AnyCancellable>()
    private let selectedBackgroundColor: UIColor = .systemBlue
    
    private var teamInvitesArray: [TeamInviteModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var selected: SelectedList = .users {
        didSet {
            guard let viewModel = viewModel else { return }
            if selected == .users {
                currentUsersButton.backgroundColor = selectedBackgroundColor
                invitesButton.backgroundColor = .systemBackground
                tableView.reloadData()
            } else {
                viewModel.fetchTeamInvites()
                invitesButton.backgroundColor = selectedBackgroundColor
                currentUsersButton.backgroundColor = .systemBackground
                tableView.reloadData()
            }
            
            viewModel.teamInvitesSubject.sink { teamInviteResult in
                switch(teamInviteResult) {
                case .failure(let error):
                    self.showMessage(withTitle: "Uh Oh", message: "Error encountered fetching outstanding invites. \(error.localizedDescription)")
                case .success(let teamInvites):
                    self.teamInvitesArray = teamInvites
                }
            }.store(in: &subscriptions)
        }
    }
    
    var viewModel: TeamUsersTabVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            if selected == .users {
                tableView.reloadData()
            }
            
            viewModel.teamInvitesSubject.sink { teamInvites in
                if self.selected == .invites {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }.store(in: &subscriptions)
        }
    }
    
    // MARK: UI Elements
    private lazy var currentUsersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Current Users", for: .normal)
        button.setTitleColor(.buttonText, for: .normal)
        button.backgroundColor = selectedBackgroundColor
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var invitesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invites", for: .normal)
        button.setTitleColor(.buttonText, for: .normal)
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TeamInvitesTabViewCell.self, forCellReuseIdentifier: TabCellIdentifiers.invites)
        tableView.register(TeamUsersTabViewCell.self, forCellReuseIdentifier: TabCellIdentifiers.users)
        tableView.rowHeight = 60
        return tableView
    }()
    
    private lazy var inviteUsersButton: BlueButton = {
        let button = BlueButton()
        button.setTitle("Invite Users", for: .normal)
        button.addTarget(self, action: #selector(onInviteTeamMemberPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: HELPERS
    override func configureView() {
        let screenWidth = UIScreen.main.bounds.size.width
        
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(inviteUsersButton)
        inviteUsersButton.centerX(inView: view, topAnchor: topSafeAnchor)
        inviteUsersButton.anchor(width: screenWidth * 0.6)
        
        view.addSubview(currentUsersButton)
        currentUsersButton.anchor(top: inviteUsersButton.bottomAnchor, left: view.leftAnchor, paddingTop: 12, width: screenWidth / 2, height: 64)
        
        view.addSubview(invitesButton)
        invitesButton.anchor(top: inviteUsersButton.bottomAnchor, left: currentUsersButton.rightAnchor, right: view.rightAnchor, paddingTop: 12, height: 64)
        
        view.addSubview(tableView)
        tableView.anchor(top:currentUsersButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    @objc func onButtonPress() {
        if selected == .users {
            selected = .invites
        } else {
            selected = .users
        }
    }
    
    @objc func onInviteTeamMemberPressed() {
        guard let viewModel = viewModel else { return }
        let inviteModal = TeamInviteUserModal()
        let inviteModalVm = TeamInviteUserModalVM(teamId: viewModel.team.teamId)
        inviteModal.viewModel = inviteModalVm
        navigationController?.present(inviteModal, animated: true)
    }
}

extension TeamUsersTabView: UITableViewDelegate {}

extension TeamUsersTabView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selected == .users {
            return viewModel?.usersSubject.value.count ?? 0
        } else {
            return teamInvitesArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selected == .users, let viewModel = viewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: TabCellIdentifiers.users, for: indexPath) as! TeamUsersTabViewCell
            cell.viewModel = TeamUsersTabViewCellVM(user: viewModel.usersSubject.value[indexPath.row])
            return cell
            
        } else if selected == .invites {
            let cell = tableView.dequeueReusableCell(withIdentifier: TabCellIdentifiers.invites, for: indexPath) as! TeamInvitesTabViewCell
            cell.viewModel = TeamInvitesTabViewCellVM(invite: teamInvitesArray[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "crash incoming")
        }
    }
    
    
}
