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
    case windowLength
    case intervalBetweenWindows
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
