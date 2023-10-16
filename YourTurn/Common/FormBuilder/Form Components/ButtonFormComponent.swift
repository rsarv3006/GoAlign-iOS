//
//  ButtonFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import Foundation

enum FormButtonType {
    case standard
    case text
}
final class ButtonFormComponent: FormComponent {
    let title: String
    let buttonType: FormButtonType

    init(id: FormField,
         title: String,
         buttonType: FormButtonType = .standard
    ) {
        self.title = title
        self.buttonType = buttonType
        super.init(id)
    }
}
