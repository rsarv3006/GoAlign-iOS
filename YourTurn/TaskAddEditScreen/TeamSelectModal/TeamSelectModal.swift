//
//  TeamSelectModal.swift
//  YourTurn
//
//  Created by rjs on 8/16/22.
//

import UIKit
import Combine

private let TEAM_SELECT = 1020
private let TEAM_MEMBER_SELECT = 1030

class TeamSelectModal: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var teams = [TeamModel]() {
        didSet {
            print(teams.forEach({ team in
                print(team.teamName)
            }))
            DispatchQueue.main.async {
                self.teamSelectTableView.reloadData()
                self.teamMemberSelectTableView.reloadData()
            }
            
        }
    }
    
    private var selectedTeamIndex: Int = 0
    
    // MARK: - UI Elements
    private lazy var closeButton: StandardButton = {
        let button = StandardButton()
        button.setTitle("CLOSE", for: .normal)
        return button
    }()
    
    private lazy var subView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .gray
        subView.layer.cornerRadius = 10
        return subView
    }()
    
    private lazy var teamTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the Team"
        return label
    }()
    
    private lazy var teamMemberTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the Team Member"
        return label
    }()
    
    private let teamSelectTableView: UITableView = {
        let tv = UITableView()
        tv.tag = TEAM_SELECT
        return tv
    }()
    
    private let teamMemberSelectTableView: UITableView = {
        let tv = UITableView()
        tv.tag = TEAM_MEMBER_SELECT
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadTeamsAndMembers()
    }
    
    func configureView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(subView)
        subView.center(inView: view)
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        subView.setWidth(screenWidth * 0.75)
        subView.setHeight(screenHeight * 0.6)
        
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
        
        teamSelectTableView.delegate = self
        teamSelectTableView.dataSource = self
        teamSelectTableView.rowHeight = 60
        
        teamMemberSelectTableView.delegate = self
        teamMemberSelectTableView.dataSource = self
        teamMemberSelectTableView.rowHeight = 60
    }
    
    @objc func onClosePressed() {
        self.dismiss(animated: true)
    }
    
    func loadTeamsAndMembers() {
        TeamService.getTeamsbyCurrentUser { teams, error in
            if let teams = teams {
                self.teams = teams
            } else if let error = error {
                Logger.log(logLevel: .Prod, message: String(describing: error))
            }
        }
    }
}

extension TeamSelectModal: UITableViewDelegate {
    
}

extension TeamSelectModal: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == TEAM_SELECT {
            return teams.count
        } else if tableView.tag == TEAM_MEMBER_SELECT {
            if teams.count > 1 {
                return teams[selectedTeamIndex].teamMembers.count
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
            cell.nameLabelString = teams[selectedTeamIndex].teamMembers[indexPath.row].username
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "crash baby")
        }
    }
    
    
}
