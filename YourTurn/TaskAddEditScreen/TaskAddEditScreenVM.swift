//
//  TaskAddEditScreenVM.swift
//  YourTurn
//
//  Created by rjs on 6/26/22.
//

import Foundation
import Combine

struct TaskAddEditScreenVM {
    let screenTitleLabelString: String = "Add Task"
    
    struct LABEL_KEYS {
        static let INTERVAL_BETWEEN_WINDOWS = "INTERVAL_BETWEEN_WINDOWS"
        static let WINDOW_LENGTH = "WINDOW_LENGTH"
    }
    
    func onTaskCreateRequest(viewController: TaskAddEditScreen, taskForm: CreateTaskDto) {
        defer {
            viewController.showLoader(false)
        }
        
        Task {
            do {
                let task = try await TaskService.createTask(taskToCreate: taskForm)
                await viewController.delegate?.onTaskScreenComplet(viewController: viewController)
                
                DispatchQueue.main.async {
                    viewController.navigationController?.popViewController(animated: true)
                }
                
            } catch {
                await viewController.showMessage(withTitle: "Uh Oh", message: "Unexpected error creating task. \(error.localizedDescription)")
                Logger.log(logLevel: .Prod, name: Logger.Events.Task.creationFailed, payload: ["error": error.localizedDescription])
            }
        }
    }
}
