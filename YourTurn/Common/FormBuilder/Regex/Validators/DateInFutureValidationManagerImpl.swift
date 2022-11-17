//
//  DateInFutureValidationManagerImpl.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import Foundation

struct DateInFutureValidationManagerImpl: ValidationManager {
    func validate(_ val: Any) throws {
            guard let date = val as? Date else {
                return
            }
            
            if Date() > date {
                throw ValidationError.custom(message: "Date needs to be in the future.")
            }
    }
}
