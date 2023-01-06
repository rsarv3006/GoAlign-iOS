//
//  TaskVM.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import Foundation

struct TaskViewScreenVM {
    let contentTitle: String
    let task: TaskModel
    
    init(task: TaskModel) {
        self.contentTitle = task.taskName
        self.task = task
    }
    
}
