//
//  ExternalLinkService.swift
//  YourTurn
//
//  Created by rjs on 11/16/22.
//

import UIKit

struct ExternalLinkService {
    static func openTermsAndConditionsLink() {
        DispatchQueue.main.async {
            let url = URL(string: "https://google.com")
            guard let url = url else { return }
            UIApplication.shared.open(url)
        }
    }
}
