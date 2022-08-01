//
//  FormContentBuilderImpl.swift
//  YourTurn
//
//  Created by rjs on 7/6/22.
//

import Combine
import Foundation

final class TaskAddEditFormContentBuilderImpl {
    private(set) var formSubmission = PassthroughSubject<[String: Any], Never>()
    
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
                                  )
                              ]),
            DateFormComponent(id: .startDate,
                              mode: .date,
                              validations: [
                                  DateInFutureValidationManagerImpl()
                              ],
                              title: "Start Date:"),
            SwitchControlledDateFormComponent(id: .endDate, mode: .date, switchLabel: "End Date", validations: [DateInFutureValidationManagerImpl()], title: ""),
            SwitchControlledTextFormComponent(id: .numberofRequiredCompletions, placeholder: "Number of Completions Needed To Close Task", switchLabel: "Completions Needed:", keyboardType: .numberPad, validations: []),
            HideableIntervalPickerFormComponent(id: .windowLength, title: "Task Window:", validations: []),
            HideableIntervalPickerFormComponent(id: .intervalBetweenWindows, title: "Time Between Tasks:", validations: []),
            TextFormComponent(id: .notes, placeholder: "Notes"),
            ButtonFormComponent(id: .taskCreationSubmit, title: "Confirm")
        ])
    ]
    
    func update(val: Any, at indexPath: IndexPath) {
        formContent[indexPath.section].items[indexPath.row].value = val
    }
    
    func validate() {
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
            
            formSubmission.send(validDict)
            
        } catch {
            print("Something is wrong with form: \(error)")
        }
    }
}
