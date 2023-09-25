//
//  ValidationError.swift
//  YourTurn
//
//  Created by rjs on 7/16/22.
//

import Foundation

enum ValidationError: Error, LocalizedError {
    case custom(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .custom(let message):
            return NSLocalizedString(message, comment: "An unexpected error occurred.")
        }
    }
}
