//
//  IntervalPickerFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import Foundation

final class HideableIntervalPickerFormComponent: FormComponent {
    let title: String
    let editValue: IntervalObject?
    
    init(id: FormField,
         title: String,
         validations: [ValidationManager] = [],
         editValue: IntervalObject? = nil
    ) {
        self.title = title
        self.editValue = editValue
        super.init(id, validations: validations)
    }
}
