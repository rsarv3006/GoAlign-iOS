//
//  ValidationError.swift
//  YourTurn
//
//  Created by rjs on 7/16/22.
//

import Foundation

enum ValidationError: Error {
    case custom(message: String)
}
