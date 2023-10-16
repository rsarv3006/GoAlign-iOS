//
//  PasswordFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/24/22.
//

import Foundation

final class PasswordFormComponent: FormComponent {
    let placeholder: String
    let confirmPlaceholder: String

    init(
        id: FormField,
        placeholder: String,
        confirmPlaceholder: String,
        validations: [ValidationManager] = []
    ) {
        self.placeholder = placeholder
        self.confirmPlaceholder = confirmPlaceholder
        super.init(id, validations: validations)
    }
}
