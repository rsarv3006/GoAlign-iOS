//
//  TextBoxFormComponent.swift
//  YourTurn
//
//  Created by rjs on 11/4/22.
//

import Foundation

import UIKit

final class TextBoxFormComponent: FormComponent {
    
    let placeholder: String
    let keyboardType: UIKeyboardType
    let isSecureTextEntryEnabled: Bool
    let autoCorrectionType: UITextAutocorrectionType
    
    init(id: FormField,
         placeholder: String,
         keyboardType: UIKeyboardType = .default,
         isSecureTextEntryEnabled: Bool = false,
         autoCorrectionType: UITextAutocorrectionType = .default,
         validations: [ValidationManager] = []
    ) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntryEnabled = isSecureTextEntryEnabled
        self.autoCorrectionType = autoCorrectionType
        super.init(id, validations: validations)
    }
}
