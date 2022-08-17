//
//  StandardButton.swift
//  YourTurn
//
//  Created by rjs on 8/16/22.
//

import Foundation
import UIKit

class StandardButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        backgroundColor = .systemGray6
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
