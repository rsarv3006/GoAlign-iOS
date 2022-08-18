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
            print(teams)
            DispatchQueue.main.async {
                self.teamSelectTableView.reloadData()
            }
            
        }
    }
    
    private var teamMembers = [UserModel]() {
        didSet {
            DispatchQueue.main.async {
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
        
        teamSelectTableView.register(UITableViewCell.self, forCellReuseIdentifier: "thing")
        teamMemberSelectTableView.register(UITableViewCell.self, forCellReuseIdentifier: "otherThing")
        
        subView.addSubview(teamSelectTableView)
        teamSelectTableView.anchor(top: subView.topAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 120)

        subView.addSubview(teamMemberSelectTableView)
        teamMemberSelectTableView.anchor(top: teamSelectTableView.topAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 66)
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
            return teams[selectedTeamIndex].teamMembers.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("HOWDY Begin")
        if tableView.tag == TEAM_SELECT {
            print("HOWDY")
            let cell = UITableViewCell()
            cell.textLabel?.text = teams[indexPath.row].teamName
            return cell
        } else if tableView.tag == TEAM_MEMBER_SELECT {
            let cell = UITableViewCell()
            cell.textLabel?.text = teams[selectedTeamIndex].teamMembers[indexPath.row].username
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "crash baby")
        }
    }
    
    
}
