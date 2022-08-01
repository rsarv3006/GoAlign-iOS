//
//  Model+toJson.swift
//  YourTurn
//
//  Created by rjs on 7/31/22.
//

import Foundation

protocol ToJsonFunc {
    func toJson() -> Data?
}
