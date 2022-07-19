//
//  FormContentBuilderImpl.swift
//  YourTurn
//
//  Created by rjs on 7/6/22.
//

import Foundation
import Combine

final class TaskAddEditFormContentBuilderImpl {
    
    private(set) var formSubmission = PassthroughSubject<[String: Any], Never>()
    
    private(set) var formContent = [
            FormSectionComponent(items: [
                TextFormComponent(id: .firstName,
                                  placeholder: "First Name",
                                  validations: [
                                  
                                    RegexValidationManagerImpl(
                                        [
                                            RegexFormItem(pattern: RegexPatterns.name,
                                                          error: .custom(message: "Invalid Name entered"))
                                        ]
                                    )
                                    
                                  ]),
                TextFormComponent(id: .lastName,
                                  placeholder: "Last Name",
                                  validations: [
                                  
                                    RegexValidationManagerImpl(
                                        [
                                            RegexFormItem(pattern: RegexPatterns.name,
                                                          error: .custom(message: "Invalid Name entered"))
                                        ]
                                    )
                                    
                                  ]),
                TextFormComponent(id: .email,
                                  placeholder: "Email",
                                  keyboardType: .emailAddress,
                                  validations: [
                                  
                                    RegexValidationManagerImpl(
                                        [
                                            RegexFormItem(pattern: RegexPatterns.emailChars,
                                                          error: .custom(message: "Invalid Email missing @")),
                                            RegexFormItem(pattern: RegexPatterns.higherThanSixChars,
                                                          error: .custom(message: "Less than 6 characters"))
                                        ]
                                    )
                                  
                                  
                                  ]),
                DateFormComponent(id: .dob,
                                  mode: .date,
                                  validations: [
                
                    DateValidationManagerImpl()
                ]),
                ButtonFormComponent(id: .submit,
                               title: "Confirm")
            ])
        ]
    
    func update(val: Any, at indexPath: IndexPath) {
        formContent[indexPath.section].items[indexPath.row].value = val
    }
    
    func validate() {
        
        do {
            
            let formComponents = formContent
                .flatMap { $0.items }
                .filter { $0.formId != .submit }
            
            for component in formComponents {
                
                for validator in component.validations {
                    
                    try validator.validate(component.value as Any)
                }
            }
            
            let validValues = formComponents.map { ($0.formId.rawValue, $0.value) }
            let validDict = Dictionary(uniqueKeysWithValues: validValues) as [String : Any]
            
            formSubmission.send(validDict)
                        
        } catch {
            print("Something is wrong with form: \(error)")
        }
    }
}
