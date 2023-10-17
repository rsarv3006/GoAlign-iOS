//
//  DateAgeLimitValidationManagerImpl.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import Foundation

struct DateAgeLimitValidationManagerImpl: ValidationManager {
    private let ageLimit: Int = 18

    func validate(_ val: Any) throws {
        guard let date = val as? Date else {
            throw ValidationError.custom(message: "Invald Value of \(val) passed")
        }

        if let calculatedYear = Calendar.current.dateComponents(
            [.year],
            from: date,
            to: Date()).year,
           calculatedYear < ageLimit {
            throw ValidationError.custom(message: "User is below the age of 18")
        }
    }
}
