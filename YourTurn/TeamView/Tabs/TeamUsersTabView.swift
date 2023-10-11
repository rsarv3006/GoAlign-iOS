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
    private let selectedBackgroundColor: UIColor = .customAccentColor ?? .systemBlue
    
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
                invitesButton.backgroundColor = .customBackgroundColor
                
                currentUsersButton.setTitleColor(.lightButtonText, for: .normal)
                invitesButton.setTitleColor(.customTitleText, for: .normal)
                tableView.reloadData()
            } else {
                viewModel.fetchTeamInvites()
                invitesButton.backgroundColor = selectedBackgroundColor
                currentUsersButton.backgroundColor = .customBackgroundColor
                
                currentUsersButton.setTitleColor(.customTitleText, for: .normal)
                invitesButton.setTitleColor(.lightButtonText, for: .normal)
                tableView.reloadData()
            }
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
            
            viewModel.shouldShowCreateInviteButton.sink { shouldShowCreateInviteButton in
                DispatchQueue.main.async {
                    self.clearView()
                    if shouldShowCreateInviteButton {
                        self.loadViewWithTeamInviteButton()
                    }
                }
            }.store(in: &subscriptions)
            
            viewModel.requestTableReload.sink { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }.store(in: &subscriptions)
            
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
    
    // MARK: UI Elements
    private lazy var currentUsersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Current Users", for: .normal)
        button.setTitleColor(.lightButtonText, for: .normal)
        button.backgroundColor = selectedBackgroundColor
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    private lazy var invitesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invites", for: .normal)
        button.setTitleColor(.customTitleText, for: .normal)
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
        button.backgroundColor = .customBackgroundColor
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TeamInvitesTabViewCell.self, forCellReuseIdentifier: TabCellIdentifiers.invites)
        tableView.register(TeamUsersTabViewCell.self, forCellReuseIdentifier: TabCellIdentifiers.users)
        tableView.rowHeight = 60
        tableView.backgroundColor = .customBackgroundColor
        return tableView
    }()
    
    private lazy var inviteUsersButton: BlueButton = {
        let button = BlueButton()
        button.setTitle("Invite Users", for: .normal)
        button.addTarget(self, action: #selector(onInviteTeamMemberPressed), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: HELPERS
    override func configureView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        if viewModel?.shouldShowCreateInviteButton.value == true {
            loadViewWithTeamInviteButton()
        } else {
            loadViewWithoutTeamInviteButton()
        }
    }
    
    private func clearView() {
        inviteUsersButton.removeFromSuperview()
        currentUsersButton.removeFromSuperview()
        invitesButton.removeFromSuperview()
        tableView.removeFromSuperview()
    }
    
    private func loadViewWithTeamInviteButton() {
        let screenWidth = UIScreen.main.bounds.size.width
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        
        view.addSubview(inviteUsersButton)
        inviteUsersButton.centerX(inView: view, topAnchor: topSafeAnchor)
        inviteUsersButton.anchor(width: screenWidth * 0.6)
        
        view.addSubview(currentUsersButton)
        currentUsersButton.anchor(top: inviteUsersButton.bottomAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 8, width: screenWidth / 2, height: 44)
        
        view.addSubview(invitesButton)
        invitesButton.anchor(top: inviteUsersButton.bottomAnchor, left: currentUsersButton.rightAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 8, height: 44)
        
        view.addSubview(tableView)
        tableView.anchor(top:currentUsersButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    private func loadViewWithoutTeamInviteButton() {
        let screenWidth = UIScreen.main.bounds.size.width
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        
        view.addSubview(currentUsersButton)
        currentUsersButton.anchor(top: topSafeAnchor, left: view.leftAnchor, paddingTop: 12, width: screenWidth / 2, height: 64)
        
        view.addSubview(invitesButton)
        invitesButton.anchor(top: topSafeAnchor, left: currentUsersButton.rightAnchor, right: view.rightAnchor, paddingTop: 12, height: 64)
        
        view.addSubview(tableView)
        tableView.anchor(top: currentUsersButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
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
        inviteModalVm.delegate = self
        inviteModal.viewModel = inviteModalVm
        navigationController?.present(inviteModal, animated: true)
    }
}

extension TeamUsersTabView: UITableViewDelegate {}

extension TeamUsersTabView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selected == .users {
            return viewModel?.users.count ?? 0
        } else {
            return teamInvitesArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selected == .users, let viewModel = viewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: TabCellIdentifiers.users, for: indexPath) as! TeamUsersTabViewCell
            cell.viewModel = TeamUsersTabViewCellVM(user: viewModel.users[indexPath.row])
            return cell
            
        } else if selected == .invites {
            let cell = tableView.dequeueReusableCell(withIdentifier: TabCellIdentifiers.invites, for: indexPath) as! TeamInvitesTabViewCell
            cell.viewModel = TeamInvitesTabViewCellVM(invite: teamInvitesArray[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "crash incoming")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && viewModel?.canUserEditTeam == true {
            let index = indexPath.row

            viewModel?.initiateDeleteUserFlow(viewController: self, index: index, type: selected)
        }
    }
}

extension TeamUsersTabView: TeamUsersReloadDelegate {
    func requestInvitesReload() {
        DispatchQueue.main.async {
            self.viewModel?.fetchTeamInvites()
        }
    }
    
    
}
