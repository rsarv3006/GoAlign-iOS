//
//  LabelFormComponent.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 9/26/23.
//

import Foundation
import UIKit

final class LabelFormComponent: FormComponent {
   
    let labelText: String
    
    init(id: FormField,
         labelText: String
    ) {
        self.labelText = labelText
        super.init(id)
    }
}
