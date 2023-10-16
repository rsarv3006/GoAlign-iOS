//
//  GeneralUIAlertMessage.swift
//  YourTurn
//
//  Created by rjs on 12/23/22.
//

import Foundation

struct GeneralUIAlertMessage {
    let title: String
    let message: String

    init(withTitle title: String, message: String) {
        self.title = title
        self.message = message
    }
}
