//
//  TeamSettingsChangeTeamManagerCellVM.swift
//  YourTurn
//
//  Created by rjs on 12/23/22.
//

import Foundation
import Combine

class TeamSettingsChangeTeamManagerCellVM {
    let changeTeamManagerButtonTitle: String = "Change Team Manager"
    
    var delegate: TeamSettingsCellsDelegate?
    private var subscriptions = Set<AnyCancellable>()
    
    private let team: TeamModel
    
    init(withTeam team: TeamModel) {
        self.team = team
    }
    
    func displayChangeTeamManagerModal() {
        let modal = ChangeTeamManagerModal()
        let modalVM = ChangeTeamManagerModalVM(team: team)
        
        modalVM.requestReload.sink { _ in
            self.delegate?.requestHomeReloadFromCell()
            self.delegate?.requestRemoveTabViewFromCell()
        }.store(in: &subscriptions)
        
        modal.viewModel = modalVM
        delegate?.requestShowModalFromCell(modal: modal)
    }
}
