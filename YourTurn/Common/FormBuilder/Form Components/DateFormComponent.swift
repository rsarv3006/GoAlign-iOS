//
//  DateFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import UIKit

final class DateFormComponent: FormComponent {

    let mode: UIDatePicker.Mode

    let title: String

    let editValue: Date?

    init(id: FormField,
         mode: UIDatePicker.Mode,
         validations: [ValidationManager] = [],
         title: String = "",
         editValue: Date? = nil
    ) {
        self.title = title
        self.mode = mode
        self.editValue = editValue
        super.init(id, validations: validations)
    }
}
