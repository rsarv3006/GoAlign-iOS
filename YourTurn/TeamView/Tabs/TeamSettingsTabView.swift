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
    
    // MARK: Helpers
    override func configureView() {
        view.addSubview(leaveTeamButton)
        leaveTeamButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(deleteTeamButton)
        deleteTeamButton.anchor(top: leaveTeamButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16)
    }
    
    @objc func onDeleteTeamPressed() {
        viewModel?.displayConfirmDeleteTeamModal(viewController: self)
    }
    
    @objc func onLeaveTeamPressed() {
        viewModel?.displayRemoveSelfFromTeamModal(viewController: self)
    }
}
