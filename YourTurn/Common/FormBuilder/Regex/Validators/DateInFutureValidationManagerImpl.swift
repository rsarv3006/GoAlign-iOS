//
//  DateInFutureValidationManagerImpl.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import Foundation

struct DateInFutureValidationManagerImpl: ValidationManager {
    func validate(_ val: Any) throws {
        print("val: \(val)")
        guard let date = val as? Date else {
            return
        }
           
        let dayInSeconds: Double = 24 * 60 * 60
        let dayAgo = Date().timeIntervalSinceNow - dayInSeconds
      
        let newCheckDate = Date(timeIntervalSinceNow: dayAgo)
        if newCheckDate > date {
                throw ValidationError.custom(message: "Date needs to be in the future.")
            }
    }
}
