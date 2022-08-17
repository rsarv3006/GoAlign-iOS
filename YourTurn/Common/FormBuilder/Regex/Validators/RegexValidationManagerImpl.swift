//
//  RegexValidationManagerImpl.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import Foundation

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
