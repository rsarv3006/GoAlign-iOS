//
//  ButtonFormComponent.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import Foundation

final class ButtonFormComponent: FormComponent {
    let title: String
    
    init(id: FormField,
         title: String) {
        self.title = title
        super.init(id)
    }
}
