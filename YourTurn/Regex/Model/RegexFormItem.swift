//
//  RegexFormItem.swift
//  YourTurn
//
//  Created by rjs on 7/16/22.
//

import Foundation

struct RegexFormItem {
    let pattern: String
    let error: ValidationError
}

protocol ValidationManager {
    func validate(_ val: Any) throws
}

struct RegexValidationManagerImpl: ValidationManager {
    private let items: [RegexFormItem]
    
    init(_ items: [RegexFormItem]) {
        self.items = items
    }
    
    func validate(_ val: Any) throws {
        let val = (val as? String) ?? ""
        
        try items.forEach({ regexItem in
            let regex = try? NSRegularExpression(pattern: regexItem.pattern)
            let range = NSRange(location: 0, length: val.count)
            if regex?.firstMatch(in: val, range: range) == nil {
                throw regexItem.error
            }
        })
    }
}

struct DateAgeLimitValidationManagerImpl: ValidationManager {
    private let ageLimit: Int = 18
    
    func validate(_ val: Any) throws {
        guard let date = val as? Date else {
            throw ValidationError.custom(message: "Invald Value of \(val) passed")
        }
        
        if let calculatedYear = Calendar.current.dateComponents([.year], from: date, to: Date()).year, calculatedYear < ageLimit {
            throw ValidationError.custom(message: "User is below the age of 18")
        }
    }
}

struct DateInFutureValidationManagerImpl: ValidationManager {
    func validate(_ val: Any) throws {
        guard let date = val as? Date else {
            throw ValidationError.custom(message: "Invald Value of \(val) passed")
        }
        
        if Date() > date {
            throw ValidationError.custom(message: "Date needs to be in the future.")
        }
    }
}
