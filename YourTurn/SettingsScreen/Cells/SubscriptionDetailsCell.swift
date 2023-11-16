//
//  SubscriptionDetailsCell.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 11/15/23.
//

import UIKit

class SubscriptionDetailsCell: UITableViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Subscription unlocks access to all features. Removes restrictions on accessing teams and tasks."
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.textColor = .customTitleText
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.center(inView: contentView)
        label.anchor(
            left: contentView.safeAreaLayoutGuide.leftAnchor,
            right: contentView.safeAreaLayoutGuide.rightAnchor,
            paddingLeft: 8,
            paddingRight: 8)
        contentView.backgroundColor = .customBackgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
