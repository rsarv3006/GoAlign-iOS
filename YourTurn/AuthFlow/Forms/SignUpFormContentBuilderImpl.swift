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
            TextFormComponent(id: .signUpUserName, placeholder: "Username", autoCorrectionType: .no, validations: [
                RegexValidationManagerImpl([
                    RegexFormItem(pattern: RegexPatterns.higherThanSixChars, error: .custom(message: "Username is too short")),
                ]),
                StringMaxLengthValidationManagerImpl(maxLength: 18, errorMessage: "Username is too long")
            ]),
            TextFormComponent(id: .signUpEmailAddress, placeholder: "Email Address", keyboardType: .emailAddress, autoCorrectionType: .no, validations: [
                RegexValidationManagerImpl([
                    RegexFormItem(pattern: RegexPatterns.emailChars, error: .custom(message: "Not a valid email"))
                ])
            ]),
            PasswordFormComponent(id: .signUpPassword, placeholder: "Password", confirmPlaceholder: "Confirm Password", validations: [
                RegexValidationManagerImpl(
                    [
                        RegexFormItem(pattern: RegexPatterns.higherThanSixteenChars,
                                      error: .custom(message: "Password must be 16 characters long."))
                    ]
                ),
            ]),
            ButtonFormComponent(id: .signUpSubmit, title: "Sign Up!"),
            ButtonFormComponent(id: .termsButton, title: "Continuing indicates acceptance of the Terms And Conditions.", buttonType: .text)
        ])
    ]
    
    func update(val: Any, at indexPath: IndexPath) {
        formContent[indexPath.section].items[indexPath.row].value = val
    }
    
    func validate() {
        do {
            let formComponents = formContent
                .flatMap { $0.items }
                .filter { $0.formId != .signUpSubmit }
            
            for component in formComponents {
                for validator in component.validations {
                    try validator.validate(component.value as Any)
                }
            }
            
            let validValues = formComponents.map { ($0.formId.rawValue, $0.value) }
            let validDict = Dictionary(uniqueKeysWithValues: validValues) as [String: Any]
            
            try formSubmission.send(SignUpCompletedForm(fromDict: validDict ))
            
        } catch {
            Logger.log(logLevel: .Prod, name: Logger.Events.Auth.signUpValidationFailed, payload: ["error": error, "message": "Something is wrong with the SignUp form"])
        }
    }
}
