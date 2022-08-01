//
//  SignUpFormContentBuilderImpl.swift
//  YourTurn
//
//  Created by rjs on 7/24/22.
//

import Foundation
import Combine

final class SignUpFormContentBuilderImpl {
    private(set) var formSubmission = PassthroughSubject<SignUpCompletedForm, Never>()
    
    private(set) var formContent = [
        FormSectionComponent(items: [
            TextFormComponent(id: .signUpUserName, placeholder: "Username", validations: [
                RegexValidationManagerImpl([
                    RegexFormItem(pattern: RegexPatterns.higherThanSixChars, error: .custom(message: "Username is too short")),
                ])
            ]),
            TextFormComponent(id: .signUpEmailAddress, placeholder: "Email Address", validations: [
                RegexValidationManagerImpl([
                    RegexFormItem(pattern: RegexPatterns.emailChars, error: .custom(message: "Not a valid email"))
                ])
            ]),
            PasswordFormComponent(id: .signUpPassword, placeholder: "Password", confirmPlaceholder: "Confirm Password", validations: [
                // Add validations
            ]),
            ButtonFormComponent(id: .signUpSubmit, title: "Sign Up!")
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
            
            try formSubmission.send(SignUpCompletedForm(fromDict: validDict ))
            
        } catch {
            print("Something is wrong with form: \(error)")
        }
    }
}
