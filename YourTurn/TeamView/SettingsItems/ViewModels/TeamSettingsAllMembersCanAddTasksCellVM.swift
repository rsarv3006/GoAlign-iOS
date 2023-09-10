//
//  AllMembersCanAddTasksCellVM.swift
//  YourTurn
//
//  Created by rjs on 12/28/22.
//

import UIKit
import Combine

class TeamSettingsAllMembersCanAddTasksCellVM {
    private(set) var settingPassThrough = CurrentValueSubject<Bool, Never>(false)
    private(set) var settingEnabledPassThrough = CurrentValueSubject<Bool, Never>(false)
    
    let switchTitle = "Can all members add tasks:"
    var delegate: TeamSettingsCellsDelegate?
    
    private let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
        
        fetchCanAllMembersAddTasksSetting()
        canUserChangeSetting()
    }
    
    func fetchCanAllMembersAddTasksSetting() {
        Task {
            do {
                let teamSettings = try await TeamService.getTeamSettings(teamId: team.teamId)
                settingPassThrough.send(teamSettings.canAllMembersAddTasks)
            } catch {
                delegate?.requestShowMessageFromCell(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }
    
    func updateSetting(newSettingValue: Bool) {
        Task {
            do {
                try await TeamService.updateTeamSettings(teamId: team.teamId, newSettingValue: newSettingValue)
                let teamSettings = try await TeamService.getTeamSettings(teamId: team.teamId)
                settingPassThrough.send(teamSettings.canAllMembersAddTasks)
            } catch {
                delegate?.requestShowMessageFromCell(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }
    
    func canUserChangeSetting() {
        Task {
            let isUserTeamManager = try? await UserService.isUserTeamManager(forTeam: team)
            if isUserTeamManager == true {
                settingEnabledPassThrough.send(true)
            }
        }
    }
}
