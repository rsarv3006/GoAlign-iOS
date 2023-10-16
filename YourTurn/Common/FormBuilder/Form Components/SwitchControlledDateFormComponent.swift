//
//  SwitchControlledDateFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import UIKit

final class SwitchControlledDateFormComponent: FormComponent {
    let switchLabel: String

    let mode: UIDatePicker.Mode

    let title: String

    let editValue: Date?

    init(id: FormField,
         mode: UIDatePicker.Mode,
         switchLabel: String,
         validations: [ValidationManager] = [],
         title: String = "",
         editValue: Date? = nil
    ) {
        self.switchLabel = switchLabel
        self.title = title
        self.mode = mode
        self.editValue = editValue
        super.init(id, validations: validations)
    }
}
