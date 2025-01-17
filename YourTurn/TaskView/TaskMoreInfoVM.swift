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
        self.createdDateLabel = "Created: \(task.createdAt.formatted())"
        self.startDateLabel = "Started: \(task.startDate.formatted())"
        self.completionsCountLabel = "Completions: \(task.completionCount)"
        self.windowLengthLabel = "Time to Complete Task: \(task.windowDuration.toString())"
        self.intervalBetweenWindowsLabel = "Time Between Tasks: \(task.intervalBetweenWindows.toString())"

        if let endDate = task.endDate {
            self.endDateLabel = "End Date: \(endDate.formatted())"
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
