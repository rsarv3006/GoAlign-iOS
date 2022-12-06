//
//  ServiceErrors.swift
//  YourTurn
//
//  Created by rjs on 12/4/22.
//

import Foundation

enum ServiceErrors: Error {
    case custom(message: String)
    case unknownUrl
    case dataSerializationFailed
    case server500(message: String)
}
