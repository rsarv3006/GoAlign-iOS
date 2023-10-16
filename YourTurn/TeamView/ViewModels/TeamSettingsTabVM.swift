//
//  TeamSettingsTabVM.swift
//  YourTurn
//
//  Created by rjs on 12/17/22.
//

import UIKit
import Combine

enum TeamSettingsVariant {
    case DeleteTeam
    case LeaveTeam
    case ChangeTeamManager
    case AllMembersCanAddTasks
}

class TeamSettingsTabVM {

    private(set) var settingsItems: [TeamSettingsVariant] = [
        .AllMembersCanAddTasks,
        .LeaveTeam,
        .DeleteTeam
    ]

    private var subscriptions = Set<AnyCancellable>()

    // Back to Tab Bar Controller
    var requestHomeReload = PassthroughSubject<Bool, Never>()
    private(set) var requestRemoveTabView = PassthroughSubject<Bool, Never>()

    // Back to Tab Controller
    private(set) var reloadTeamSettingsTable = PassthroughSubject<Void, Never>()
    private(set) var requestShowLoader = PassthroughSubject<Bool, Never>()
    private(set) var requestShowAlert = PassthroughSubject<UIAlertController, Never>()
    private(set) var requestShowMessage = PassthroughSubject<GeneralUIAlertMessage, Never>()
    private(set) var requestShowModal = PassthroughSubject<UIViewController, Never>()

    let team: TeamModel

    init(team: TeamModel) {
        self.team = team
        checkShouldShowChangeTeamManagerButton()
    }

    private func checkShouldShowChangeTeamManagerButton() {
        Task {
            let isUserTeamManager = try? await UserService.isUserTeamManager(forTeam: team)

            if isUserTeamManager == true {
                settingsItems.insert(.ChangeTeamManager, at: 1)
                reloadTeamSettingsTable.send(Void())
            }
        }
    }
}

extension TeamSettingsTabVM: TeamSettingsCellsDelegate {
    func requestShowModalFromCell(modal: UIViewController) {
        self.requestShowModal.send(modal)
    }

    func requestShowMessageFromCell(withTitle: String, message: String) {
        self.requestShowMessage.send(GeneralUIAlertMessage(withTitle: withTitle, message: message))
    }

    func requestHomeReloadFromCell() {
        self.requestHomeReload.send(true)
    }

    func requestRemoveTabViewFromCell() {
        self.requestRemoveTabView.send(true)
    }

    func requestShowLoaderFromCell(isVisible: Bool) {
        self.requestShowLoader.send(isVisible)
    }

    func requestShowAlertFromCell(alert: UIAlertController) {
        self.requestShowAlert.send(alert)
    }
}
