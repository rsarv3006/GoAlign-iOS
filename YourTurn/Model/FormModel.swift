//
//  FormModel.swift
//  YourTurn
//
//  Created by rjs on 7/6/22.
//

import UIKit

protocol FormItem {
    var id: UUID { get }
    var formId: FormField { get }
    var validations: [ValidationManager] { get }
}

protocol FormSectionItem {
    var id: UUID { get }
    var items: [FormComponent] { get }
    init(items: [FormComponent])
}

enum FormField: String, CaseIterable {
    case taskName
    case notes
    case startDate
    case endDate
    case submit
    case numberofRequiredCompletions
}

final class FormSectionComponent: FormSectionItem, Hashable {
    
    let id: UUID = UUID()
    var items: [FormComponent]
    
    required init(items: [FormComponent]) {
        self.items = items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FormSectionComponent, rhs: FormSectionComponent) -> Bool {
        lhs.id == rhs.id
    }
}

class FormComponent: FormItem, Hashable {
    
    let id = UUID()
    let formId: FormField
    var validations: [ValidationManager]
    var value: Any?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FormComponent, rhs: FormComponent) -> Bool {
        lhs.id == rhs.id
    }
    
    init(_ id: FormField,
         validations: [ValidationManager] = []) {
        self.formId = id
        self.validations = validations
    }
}

final class TextFormComponent: FormComponent {
    
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    init(id: FormField,
         placeholder: String,
         keyboardType: UIKeyboardType = .default,
         validations: [ValidationManager] = []) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        super.init(id, validations: validations)
    }
}

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

final class ButtonFormComponent: FormComponent {
    let title: String
    
    init(id: FormField,
         title: String) {
        self.title = title
        super.init(id)
    }
}

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
