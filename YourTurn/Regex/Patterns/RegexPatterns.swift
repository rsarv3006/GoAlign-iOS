//
//  RegexPatterns.swift
//  YourTurn
//
//  Created by rjs on 7/16/22.
//

import Foundation

enum RegexPatterns {
    static let emailChars = ".*[@].*"
    static let higherThanSixChars = "^.{6,}$"
    static let name = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
}
