//
//  SettingsScreenVM.swift
//  YourTurn
//
//  Created by rjs on 9/14/22.
//

import Foundation

enum SettingsVariant {
    case termsAndPrivacy
    case deleteUser
    case subscribeMembership
    case restorePurchases
    case lifetimeUnlock
    case subscriptionDetails
}

struct SettingsItem {
    let id: SettingsVariant
    let title: String

    init(id: SettingsVariant, title: String) {
        self.id = id
        self.title = title
    }
}

class SettingsScreenVM {
    let screenTitle = "Settings"
    let settingsItems: [SettingsVariant] = [
        .termsAndPrivacy,
        .subscribeMembership,
        .subscriptionDetails,
        .lifetimeUnlock,
        .restorePurchases,
        .deleteUser
    ]
}
