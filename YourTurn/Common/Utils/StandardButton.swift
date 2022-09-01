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
        backgroundColor = .systemGray5
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        addTarget(self, action: #selector(onHighLight), for: .touchDown)
        addTarget(self, action: #selector(onNormal), for: .touchUpInside)
        addTarget(self, action: #selector(onNormal), for: .touchUpOutside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onHighLight() {
        backgroundColor = .systemGray6
    }
    
    @objc func onNormal() {
        backgroundColor = .systemGray5
    }

}
