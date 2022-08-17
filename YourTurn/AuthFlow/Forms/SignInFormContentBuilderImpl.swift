//
//  SignInFormContentBuilderImpl.swift
//  YourTurn
//
//  Created by rjs on 8/11/22.
//

import Foundation
import Combine

final class SignInFormContentBuilderImpl {
    private(set) var formSubmission = PassthroughSubject<SignInCompletedForm, Never>()
    
    private(set) var formContent = [
        FormSectionComponent(items: [
            TextFormComponent(id: .signInEmailAddress, placeholder: "Email Address", keyboardType: .emailAddress, autoCorrectionType: .no, validations: [
                RegexValidationManagerImpl([
                    RegexFormItem(pattern: RegexPatterns.emailChars, error: .custom(message: "Not a valid email"))
                ])
            ]),
            TextFormComponent(id: .signInPassword, placeholder: "Password", keyboardType: .default, isSecureTextEntryEnabled: true, autoCorrectionType: .no, validations: []),
            ButtonFormComponent(id: .signInSubmit, title: "Sign In!")
        ])
    ]
    
    func update(val: Any, at indexPath: IndexPath) {
        formContent[indexPath.section].items[indexPath.row].value = val
    }
    
    func validate() {
        do {
            let formComponents = formContent
                .flatMap { $0.items }
                .filter { $0.formId != .signInSubmit }
            
            for component in formComponents {
                for validator in component.validations {
                    try validator.validate(component.value as Any)
                }
            }
            
            let validValues = formComponents.map { ($0.formId.rawValue, $0.value) }
            let validDict = Dictionary(uniqueKeysWithValues: validValues) as [String: Any]
            
            try formSubmission.send(SignInCompletedForm(fromDict: validDict ))
            
        } catch {
            Logger.log(logLevel: .Prod, message: "Something is wrong with SignIn form: \(error)")
        }
    }
}
