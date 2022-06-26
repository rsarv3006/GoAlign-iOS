//
//  HomeScreenTaskCellVM.swift
//  YourTurn
//
//  Created by rjs on 6/24/22.
//

import Foundation

struct HomeScreenTaskCellVM {
    let taskNameLabelString: String
    let timeIntervalLabelString: String
    
    init(withTask task: GqlTasksByAssignedUserIdTaskObject) {
        taskNameLabelString = task.taskName
        // TODO: - Figure out what this label should say
        timeIntervalLabelString = task.startDate
    }
}
