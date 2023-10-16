//
//  StringMaxLengthValidationManagerImpl.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import Foundation

struct StringMaxLengthValidationManagerImpl: ValidationManager {
    private let maxLength: Int
    private let errorMessage: String

    init(maxLength: Int, errorMessage: String) {
        self.maxLength = maxLength
        self.errorMessage = errorMessage
    }

    func validate(_ val: Any) throws {
        guard let val = val as? String else {
            throw ValidationError.custom(message: "Invald Value of \(val) passed. Expected String.")
        }

        if val.count > maxLength {
            throw ValidationError.custom(message: errorMessage)
        }
    }
}
