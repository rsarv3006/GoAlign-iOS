//
//  ModalFormComponent.swift
//  YourTurn
//
//  Created by rjs on 8/15/22.
//

import Foundation
import UIKit

final class ModalFormComponent: FormComponent {
    let buttonTitle: String
    let viewControllerToOpen: ModalViewController
    
    init(id: FormField,
         buttonTitle: String,
         viewControllerToOpen: ModalViewController,
         validations: [ValidationManager] = []
    ) {
        self.buttonTitle = buttonTitle
        self.viewControllerToOpen = viewControllerToOpen
        super.init(id, validations: validations)
    }
}
