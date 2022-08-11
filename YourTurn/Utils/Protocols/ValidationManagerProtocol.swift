//
//  ValidationManager.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import Foundation

protocol ValidationManager {
    func validate(_ val: Any) throws
}
