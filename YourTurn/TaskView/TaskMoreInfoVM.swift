//
//  TaskMoreInfoVM.swift
//  YourTurn
//
//  Created by Robby on 10/10/22.
//

import Foundation

struct TaskMoreInfoVM {
    // MARK: - Label Values
    let titleLabel: String = "More Info"
    let creatorLabel: String
    let createdDateLabel: String
    let startDateLabel: String
    let endDateLabel: String
    let requiredCompletionsLabel: String
    let completionsCountLabel: String
    let notesLabel: String
    let windowLengthLabel: String
    let intervalBetweenWindowsLabel: String
    
    // MARK: - Field Visibility Flags
    let isEndDateLabelVisible: Bool
    let isRequiredCompletionsLabelVisible: Bool
    let isNotesLabelVisible: Bool
    
    // MARK: - Lifecycle
    init(task: TaskModel) {
        self.creatorLabel = "Created By: \(task.creator.username)"
        self.createdDateLabel = "Created: \(task.createdAt.ISO8601Format())"
        self.startDateLabel = "Started: \(task.startDate.ISO8601Format())"
        self.completionsCountLabel = "Completions: \(task.completionCount)"
        self.windowLengthLabel = task.windowLength.toString()
        self.intervalBetweenWindowsLabel = task.intervalBetweenWindows.toString()
        
        if let endDate = task.endDate {
            self.endDateLabel = "End Date: \(endDate.ISO8601Format())"
            self.isEndDateLabelVisible = true
        } else {
            self.endDateLabel = ""
            self.isEndDateLabelVisible = false
        }

        if let requiredCompletions = task.requiredCompletionsNeeded, requiredCompletions > 0 {
            self.requiredCompletionsLabel = "Required Completions: \(requiredCompletions)"
            self.isRequiredCompletionsLabelVisible = true
        } else {
            self.requiredCompletionsLabel = ""
            self.isRequiredCompletionsLabelVisible = false
        }

        if let notes = task.notes {
            self.notesLabel = notes
            self.isNotesLabelVisible = true
        } else {
            self.notesLabel = ""
            self.isNotesLabelVisible = false
        }
    }
}
