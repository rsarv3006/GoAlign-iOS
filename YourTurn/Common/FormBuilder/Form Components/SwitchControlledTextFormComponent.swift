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
    let editValue: String?
    
    init(id: FormField,
         placeholder: String,
         switchLabel: String,
         keyboardType: UIKeyboardType = .default,
         validations: [ValidationManager] = [],
         editValue: String? = nil
    ) {
        self.switchLabel = switchLabel
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.editValue = editValue
        super.init(id, validations: validations)

    }
}
