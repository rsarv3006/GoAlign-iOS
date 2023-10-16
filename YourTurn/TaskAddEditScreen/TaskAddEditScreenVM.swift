//
//  TaskAddEditScreenVM.swift
//  YourTurn
//
//  Created by rjs on 6/26/22.
//

import Foundation
import Combine

enum TaskMutationStatus {
    case taskCreate
    case taskEdit
}

class TaskAddEditScreenVM {
    let screenTitleLabelString: String = "Add Task"

    struct LABEL_KEYS {
        static let INTERVAL_BETWEEN_WINDOWS = "INTERVAL_BETWEEN_WINDOWS"
        static let WINDOW_LENGTH = "WINDOW_LENGTH"
    }

    let taskMutationStatus: TaskMutationStatus
    private(set) var taskToEdit: TaskModel?
    private(set) var requestReload = PassthroughSubject<Void, Never>()

    init() {
        taskMutationStatus = .taskCreate
    }

    init(fromTask taskToEdit: TaskModel) {
        taskMutationStatus = .taskEdit
        self.taskToEdit = taskToEdit
    }

    func onTaskSubmit(viewController: TaskAddEditScreen, taskForm: CreateTaskDto) {
        defer {
            viewController.showLoader(false)
        }

        Task {
            do {
                _ = try await TaskService.createTask(taskToCreate: taskForm)
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

    func onTaskUpdate(viewController: TaskAddEditScreen, taskForm: UpdateTaskDto) {
        defer {
            viewController.showLoader(false)
        }
        Task {
            do {
                guard let taskId = taskToEdit?.taskId else { throw ServiceErrors.custom(message: "No task id when trying to edit a task.")}
                taskForm.insertTaskId(taskId: taskId)
                try await TaskService.updateTask(updateTaskDto: taskForm)

                DispatchQueue.main.async {
                    viewController.dismiss(animated: true)
                }
                requestReload.send(Void())
            } catch {
                await viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }
}
