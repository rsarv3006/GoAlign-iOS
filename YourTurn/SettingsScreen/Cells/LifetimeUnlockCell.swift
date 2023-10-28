//
//  LifetimeUnlockCell.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 10/27/23.
//

import UIKit

class LifetimeUnlockCell: UITableViewCell {
    private var debounceTimer: Timer?

    private lazy var lifetimeUnlock: BlueButton = {
        let button = BlueButton()
        button.setTitle("Permanent Unlock - $19.99", for: .normal)
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
        contentView.addSubview(lifetimeUnlock)
        contentView.backgroundColor = .customBackgroundColor
        lifetimeUnlock.anchor(
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
        lifetimeUnlock.addTarget(self, action: #selector(purchaseLifetimeUnlock), for: .touchUpInside)
    }

    @objc func purchaseLifetimeUnlock() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            Task {
                await store.requestProducts()

                if let lifetimeUnlock = store.goAlignLifetimeUnlock {
                    _ = try? await store.purchase(lifetimeUnlock)
                }
            }
        }
    }
}
