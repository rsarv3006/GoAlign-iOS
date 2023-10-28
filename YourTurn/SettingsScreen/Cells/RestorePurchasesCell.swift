//
//  RestorePurchasesCell.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 10/27/23.
//

import UIKit
import StoreKit

class RestorePurchasesCell: UITableViewCell {
    private var debounceTimer: Timer?

    private lazy var restorePurchasesButton: BlueButton = {
        let button = BlueButton()
        button.setTitle("Restore Purchases", for: .normal)
        return button
    }()

    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureInteractables()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    func configureView() {
        contentView.addSubview(restorePurchasesButton)
        contentView.backgroundColor = .customBackgroundColor
        restorePurchasesButton.anchor(
            top: contentView.topAnchor,
            left: contentView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: contentView.rightAnchor,
            paddingTop: 2,
            paddingLeft: 8,
            paddingBottom: 2,
            paddingRight: 8)
    }

    func configureInteractables() {
        restorePurchasesButton.addTarget(self, action: #selector(onRestorePurchasesPressed), for: .touchUpInside)
    }

    @objc func onRestorePurchasesPressed() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            Task {
                try? await AppStore.sync()
            }
        }
    }
}
