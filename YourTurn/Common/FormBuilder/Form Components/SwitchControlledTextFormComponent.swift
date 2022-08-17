//
//  SwitchControlledTextFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import UIKit

final class SwitchControlledTextFormComponent: FormComponent {
    let switchLabel: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    init(id: FormField,
         placeholder: String,
         switchLabel: String,
         keyboardType: UIKeyboardType = .default,
         validations: [ValidationManager] = []) {
        self.switchLabel = switchLabel
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        super.init(id, validations: validations)

    }
}
