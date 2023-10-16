//
//  LabelWithCustomTextColor.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 9/23/23.
//

import UIKit

class LabelWithCustomTextColor: UILabel {

    override init (frame: CGRect) {
        super.init(frame: frame)
        textColor = .customText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
