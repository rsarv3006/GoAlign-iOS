//
//  FormContentBuilderImpl.swift
//  YourTurn
//
//  Created by rjs on 7/6/22.
//

import Combine
import UIKit

enum TaskAddEditType {
    case add
    case edit
}
final class TaskAddEditFormContentBuilderImpl {
    let taskAddEditType: TaskAddEditType
    private(set) var taskToEdit: TaskModel? = nil
    private(set) var assignedUserId: UUID? = nil
    
    init() {
        taskAddEditType = .add
    }
    
    init(fromTask taskToEdit: TaskModel) {
        self.taskToEdit = taskToEdit
        taskAddEditType = .edit
        var requiredCompletionsString: String? = nil
        if let requiredCompletionsNumber = taskToEdit.requiredCompletionsNeeded, requiredCompletionsNumber > 0 {
            requiredCompletionsString = String(requiredCompletionsNumber)
        }
        
        if let taskEntry = taskToEdit.findCurrentTaskEntry() {
            assignedUserId = taskEntry.assignedUser.userId
        }
        
        let editAssignedTeamMemberModalVM = EditAssignedTeamMemberModalVM(teamId: taskToEdit.teamId, currentlyAssignedUserId: assignedUserId)
        let editAssignedTeamMemberModal = EditAssignedTeamMemberModal()
        editAssignedTeamMemberModal.viewModel = editAssignedTeamMemberModalVM
        
        formContent = [
            FormSectionComponent(items: [
                TextFormComponent(id: .taskName,
                                  placeholder: "Task Name",
                                  validations: [
                                      RegexValidationManagerImpl(
                                          [
                                              RegexFormItem(pattern: RegexPatterns.name,
                                                            error: .custom(message: "Invalid task name entered"))
                                          ]
                                      ),
                                      StringMaxLengthValidationManagerImpl(maxLength: 32, errorMessage: "Task Name is too long")
                                  ],
                                  editValue: taskToEdit.taskName
                                 ),
                SwitchControlledDateFormComponent(id: .endDate, mode: .date, switchLabel: "End Date", validations: [DateInFutureValidationManagerImpl()], title: "", editValue: taskToEdit.endDate),
                SwitchControlledTextFormComponent(id: .requiredCompletionsNeeded, placeholder: "Number of Completions Needed To Close Task", switchLabel: "Completions Needed:", keyboardType: .numberPad, validations: [], editValue: requiredCompletionsString),
                HideableIntervalPickerFormComponent(id: .windowLength, title: "Task Window:", validations: [], editValue: taskToEdit.windowDuration),
                HideableIntervalPickerFormComponent(id: .intervalBetweenWindows, title: "Time Between Tasks:", validations: [], editValue: taskToEdit.intervalBetweenWindows),
                ModalFormComponent(id: .taskTeamPicker, buttonTitle: "Select Team", viewControllerToOpen: editAssignedTeamMemberModal),
                TextBoxFormComponent(id: .notes, placeholder: "Notes", editValue: taskToEdit.notes),
                ButtonFormComponent(id: .taskCreationSubmit, title: "Update")
            ])
        ]
        
        if taskAddEditType == .edit {
            formContent[0].items.insert(LabelFormComponent(id: .taskEditTitle, labelText: "Edit Task"), at: 0)
            formContent[0].items.append(ButtonFormComponent(id: .taskEditCancel, title: "Cancel"))
        
        }
    }
    
    private(set) var formSubmission = PassthroughSubject<Result<CreateTaskDto, Error>, Never>()
    private(set) var formSubmissionUpdate = PassthroughSubject<Result<UpdateTaskDto, Error>, Never>()
    
    private(set) var formContent = [
        FormSectionComponent(items: [
            TextFormComponent(id: .taskName,
                              placeholder: "Task Name",
                              validations: [
                                  RegexValidationManagerImpl(
                                      [
                                          RegexFormItem(pattern: RegexPatterns.name,
                                                        error: .custom(message: "Invalid task name entered"))
                                      ]
                                  ),
                                  StringMaxLengthValidationManagerImpl(maxLength: 32, errorMessage: "Task Name is too long")
                              ]),
            DateFormComponent(id: .startDate,
                              mode: .date,
                              validations: [
                                  DateInFutureValidationManagerImpl()
                              ],
                              title: "Start Date:"),
            SwitchControlledDateFormComponent(id: .endDate, mode: .date, switchLabel: "End Date", validations: [DateInFutureValidationManagerImpl()], title: ""),
            SwitchControlledTextFormComponent(id: .requiredCompletionsNeeded, placeholder: "Number of Completions Needed To Close Task", switchLabel: "Completions Needed:", keyboardType: .numberPad, validations: []),
            HideableIntervalPickerFormComponent(id: .windowLength, title: "Task Window:", validations: []),
            HideableIntervalPickerFormComponent(id: .intervalBetweenWindows, title: "Time Between Tasks:", validations: []),
            ModalFormComponent(id: .taskTeamPicker, buttonTitle: "Select Team", viewControllerToOpen: TeamSelectModal()),
            TextBoxFormComponent(id: .notes, placeholder: "Notes"),
            ButtonFormComponent(id: .taskCreationSubmit, title: "Create")
        ])
    ]
    
    func update(val: Any, at indexPath: IndexPath) {
        formContent[indexPath.section].items[indexPath.row].value = val
    }
    
    func validate() {
        switch taskAddEditType {
        case .add:
            validateCreate()
        case .edit:
            validateEdit()
        }
    }
    
    private func validateEdit() {
        do {
            do {
                let formComponents = formContent
                    .flatMap { $0.items }
                    .filter { $0.formId != .taskCreationSubmit }
                
                for component in formComponents {
                    for validator in component.validations {
                        try validator.validate(component.value as Any)
                    }
                }
                
                let validValues = formComponents.map { ($0.formId.rawValue, $0.value) }
                let validDict = Dictionary(uniqueKeysWithValues: validValues) as [String: Any]
                
                let uid = AppState.getInstance().currentUser?.userId
                
                do {
                    guard let taskToEdit = taskToEdit else { throw ServiceErrors.custom(message: "No Task to edit.")}
                    try formSubmissionUpdate.send(.success(UpdateTaskDto(from: validDict, uid: uid, taskToUpdate: taskToEdit, assignedUser: assignedUserId)))
                } catch {
                    formSubmissionUpdate.send(.failure(error))
                    Logger.log(logLevel: .Prod, name: Logger.Events.Task.creationValidationFailed, payload: ["error": error])
                }
                
            } catch {
                formSubmissionUpdate.send(.failure(error))
                Logger.log(logLevel: .Prod, name: Logger.Events.Task.updateValidationFailed, payload: ["error": error])
            }
        }
    }
    
    private func validateCreate() {
        do {
            let formComponents = formContent
                .flatMap { $0.items }
                .filter { $0.formId != .taskCreationSubmit }
            
            for component in formComponents {
                for validator in component.validations {
                    try validator.validate(component.value as Any)
                }
            }
            
            let validValues = formComponents.map { ($0.formId.rawValue, $0.value) }
            let validDict = Dictionary(uniqueKeysWithValues: validValues) as [String: Any]
           
            let appState = AppState.getInstance()
            let uid = appState.currentUser?.userId
           
            print("CURENT USER ID: \(AppState.getInstance().currentUser.debugDescription)")
            do {
                try formSubmission.send(.success(CreateTaskDto(from: validDict, uid: uid)))
            } catch {
                formSubmission.send(.failure(error))
                Logger.log(logLevel: .Prod, name: Logger.Events.Task.creationValidationFailed, payload: ["error": error])
            }
            
        } catch {
            formSubmission.send(.failure(error))
            Logger.log(logLevel: .Prod, name: Logger.Events.Task.creationValidationFailed, payload: ["error": error])
        }
    }
}
