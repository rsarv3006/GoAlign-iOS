//
//  FieldVisibilityProtocol.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import Foundation

enum ShowHideLabelVariant {
    case show
    case hide
}

protocol FieldVisibilityHandlers {
    func manipulateErrorLabelVisibility(_ showHideVariant: ShowHideLabelVariant)
    func manipulateFieldVisibility(_ showHideVariant: ShowHideLabelVariant)
}
