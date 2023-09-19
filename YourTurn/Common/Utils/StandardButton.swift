//
//  StandardButton.swift
//  YourTurn
//
//  Created by rjs on 8/16/22.
//

import Foundation
import UIKit

class StandardButton: UIButton {
    private var touchUpTimer = Timer()
    
    private var onHightLightColor = UIColor.systemGray6
    private var onNormalColor = UIColor.systemGray5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        backgroundColor = .systemGray5
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        addTarget(self, action: #selector(onHighLight), for: .touchDown)
        addTarget(self, action: #selector(onNormal), for: .touchUpInside)
        addTarget(self, action: #selector(onNormal), for: .touchUpOutside)
        self.setTitleColor(.buttonText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonColors(backgroundColor: UIColor, onTouchColor: UIColor) {
        onNormalColor = backgroundColor
        onHightLightColor = onTouchColor
        self.backgroundColor = backgroundColor
    }
    
    @objc func onHighLight() {
        backgroundColor = onHightLightColor
    }
    
    @objc func onNormal() {
        touchUpTimer.invalidate()
        touchUpTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { _ in
            DispatchQueue.main.async {
                self.backgroundColor = self.onNormalColor
            }
        })
        
    }

}

class AlertButton: StandardButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setButtonColors(backgroundColor: .systemRed, onTouchColor: .systemGray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BlueButton: StandardButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setButtonColors(backgroundColor: .customAccentColor ?? .systemBlue, onTouchColor: .systemGray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
