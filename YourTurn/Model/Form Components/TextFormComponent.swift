//
//  TextFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import UIKit

final class TextFormComponent: FormComponent {
    
    let placeholder: String
    let keyboardType: UIKeyboardType
    let isSecureTextEntryEnabled: Bool
    
    init(id: FormField,
         placeholder: String,
         keyboardType: UIKeyboardType = .default,
         validations: [ValidationManager] = [],
         isSecureTextEntryEnabled: Bool = false
    ) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntryEnabled = isSecureTextEntryEnabled
        super.init(id, validations: validations)
    }
}
