//
//  Theme.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 9/17/23.
//

import UIKit
// https://colorkit.co/palette/6f956b-aab39c-e6d0cf-003f69-d6e0d1/
// #0d0e07, #2e86ab, #380036, #d2d4c8, #857885
struct ColorTheme {
    private static let colors = ["#6f956b","#aab39c","#9ce2ed","#003f69","#d6e0d1"]
   
    static let darkPrimary1 = "#003f69"
    static let lightPrimary1 = "#d6e0d1"
    static let tertiary = "#9ce2ed"
    
}

extension UIColor {
    static let buttonText = UIColor(named: "ButtonText")
    static let customText = UIColor(named: "ButtonText")
    static let customTitleText = UIColor(named: "ButtonText")
    static let customBackgroundColor = UIColor(named: "CustomBackgroundColor")
    static let customAccentColor = UIColor(named: "AccentColor")
}
