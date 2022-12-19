//
//  GroupSettingsTabView.swift
//  YourTurn
//
//  Created by rjs on 11/6/22.
//

import UIKit

class TeamSettingsTabView: YtViewController {
    
    var viewModel: TeamSettingsTabVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            deleteTeamButton.setTitle(viewModel.deleteTeamButtonTitle, for: .normal)
            leaveTeamButton.setTitle(viewModel.leaveTeamButtonTitle, for: .normal)
        }
    }
    
    // MARK: UI Elements
    private lazy var leaveTeamButton: AlertButton = {
        let button = AlertButton()
        button.addTarget(self, action: #selector(onLeaveTeamPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteTeamButton: AlertButton = {
        let button = AlertButton()
        button.addTarget(self, action: #selector(onDeleteTeamPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        configureView()
    }
    
    override func configureView() {
        view.addSubview(leaveTeamButton)
        leaveTeamButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(deleteTeamButton)
        deleteTeamButton.anchor(top: leaveTeamButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16)
    }
    
    @objc func onDeleteTeamPressed() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Delete Team", message: "Are you sure you want to delete this team?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }
            
            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                self.viewModel?.onRequestDeleteTeam(viewController: self)
                Logger.log(logLevel: .Prod, name: Logger.Events.Team.deleteAttempt, payload: ["teamId":"\(String(describing: self.viewModel?.team.teamId))"])
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            self.present(alert, animated: true)
            
        }
    }
    
    @objc func onLeaveTeamPressed() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Leave Team", message: "Are you sure you want to leave this team?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }
            
            let confirmAction = UIAlertAction(title: "Yes I'm Sure", style: .destructive) { _ in
                alert.removeFromParent()
                self.viewModel?.onRemoveSelfFromTeam(viewController: self)
                Logger.log(logLevel: .Prod, name: Logger.Events.Team.leaveAttempt, payload: ["teamId":"\(String(describing: self.viewModel?.team.teamId))"])
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            self.present(alert, animated: true)
            
        }
    }
}
