//
//  TeamTasksTabViewCellVM.swift
//  YourTurn
//
//  Created by rjs on 11/7/22.
//

import Foundation

struct TeamTasksTabViewCellVM {
    
    private let task: TaskModel
    
    let taskLabel: String
    
    init(task: TaskModel) {
        self.task = task
        
        self.taskLabel = task.taskName
    }
}
