//
//  ServiceErrors.swift
//  YourTurn
//
//  Created by rjs on 12/4/22.
//

import Foundation

enum ServiceErrors: Error, LocalizedError {
    case custom(message: String)
    case unknownUrl
    case dataSerializationFailed(dataObjectName: String)
    
    public var errorDescription: String? {
        switch self {
        case .custom(let message):
            return NSLocalizedString(message, comment: "An unexpected error occurred.")
        case .unknownUrl:
            return NSLocalizedString("An error occurred connecting.", comment: "Unable to connect.")
        case .dataSerializationFailed(let dataObjectName):
            return NSLocalizedString("An error occurred parsing serialized data. Unable to serialize \(dataObjectName)", comment: "")
        }
    }
}
