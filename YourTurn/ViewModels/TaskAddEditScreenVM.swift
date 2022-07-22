//
//  TaskAddEditScreenVM.swift
//  YourTurn
//
//  Created by rjs on 6/26/22.
//

import Foundation

struct TaskAddEditScreenVM {
    let screenTitleLabelString: String = "Add Task"
    let taskNameTitleLabelString: String = "Task Name:"
    let startDateTitleLabelString: String = "Task Start Date:"
    let endDateTitleLabelString: String = "Task End Date:"
    let requiredCompletionsTitleLabelString: String = "Minimum Number of Completions:"
    let intervalBetweenWindowsTitleLabelString: String = "Amount of Time between Task completions:"
    let windowLengthTitleLabelString: String = "Length of Task Window:"
    let openTeamModalButtonString: String = "Select Team"
    let openAssignedUserModalButtonString: String = "Select first assigned user"
    let noteTitleLabelString: String = "Notes:"
    
    struct LABEL_KEYS {
        static let INTERVAL_BETWEEN_WINDOWS = "INTERVAL_BETWEEN_WINDOWS"
        static let WINDOW_LENGTH = "WINDOW_LENGTH"
    }
}
