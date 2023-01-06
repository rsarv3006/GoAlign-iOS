//
//  TeamTaskModalVM.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/4/23.
//

import Foundation
import Combine

class TeamTaskModalVM {
    var requestRefreshTeam = PassthroughSubject<Bool, Never>()
    
    let contentTitle: String
    let task: TaskModel
    
    init(task: TaskModel) {
        self.contentTitle = task.taskName
        self.task = task
    }
    
}
