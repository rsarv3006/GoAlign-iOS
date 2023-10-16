//
//  FormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import Foundation

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
