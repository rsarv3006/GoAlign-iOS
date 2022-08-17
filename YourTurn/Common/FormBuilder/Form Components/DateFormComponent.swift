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
    
    init(id: FormField,
         mode: UIDatePicker.Mode,
         validations: [ValidationManager] = [],
         title: String = ""
    ) {
        self.title = title
        self.mode = mode
        super.init(id, validations: validations)
    }
}
