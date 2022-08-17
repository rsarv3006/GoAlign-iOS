//
//  IntervalPickerFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import Foundation

final class HideableIntervalPickerFormComponent: FormComponent {
    let title: String
    
    init(id: FormField,
         title: String,
         validations: [ValidationManager] = []
    ) {
        self.title = title
        super.init(id, validations: validations)
    }
}
