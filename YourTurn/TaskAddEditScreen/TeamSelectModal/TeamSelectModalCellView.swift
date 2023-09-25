//
//  TeamSelectModalCellView.swift
//  YourTurn
//
//  Created by rjs on 8/17/22.
//

import Foundation
import UIKit

class TeamSelectModalCellView: UITableViewCell {
    
    var nameLabelString: String? {
        didSet {
            nameLabel.text = nameLabelString
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .customText
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        backgroundColor = .customBackgroundColor
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.customAccentColor
        selectedBackgroundView = bgColorView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        addSubview(nameLabel)
        nameLabel.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
    }
}
