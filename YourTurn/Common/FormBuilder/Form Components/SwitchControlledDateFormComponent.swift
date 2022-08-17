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
    
    init(id: FormField,
         mode: UIDatePicker.Mode,
         switchLabel: String,
         validations: [ValidationManager] = [],
         title: String = ""
    ) {
        self.switchLabel = switchLabel
        self.title = title
        self.mode = mode
        super.init(id, validations: validations)
    }
}
