//
//  GroupTabBarVM.swift
//  YourTurn
//
//  Created by rjs on 11/6/22.
//

import Foundation
import Combine

struct TeamTabBarControllerVM {
    
    private(set) var requestHomeReload = PassthroughSubject<Bool, Never>()
    
    let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
    }
    
    func refetchTeam() {
        
    }
}
