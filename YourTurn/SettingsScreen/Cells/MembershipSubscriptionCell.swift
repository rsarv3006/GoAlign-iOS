//
//  MembershipSubscriptionCell.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 10/22/23.
//

import UIKit

class MembershipSubscriptionCell: UITableViewCell {
    private var debounceTimer: Timer?

    private lazy var membershipSubscriptionButton: BlueButton = {
        let button = BlueButton()
        button.setTitle("Membership - $1.99/month", for: .normal)
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
        contentView.addSubview(membershipSubscriptionButton)
        contentView.backgroundColor = .customBackgroundColor
        membershipSubscriptionButton.anchor(
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
        membershipSubscriptionButton.addTarget(self, action: #selector(onSubscribePressed), for: .touchUpInside)
    }

    @objc func onSubscribePressed() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.requestPurchaseSubscription()
        }
    }

    func requestPurchaseSubscription() {
        print("on Subscribe pressed")
        Task {
            await store.requestProducts()

            guard let product = store.goAlignMembershipPurchase else {
                print("product is nil")
                return
            }

            _ = try? await store.purchase(product)

        }
    }
}
