//
//  AlertModalService.swift
//  YourTurn
//
//  Created by rjs on 11/24/22.
//

import UIKit

struct AlertModalService {
    static func openAlert(
        viewController: UIViewController,
        modalMessage: String,
        modalTitle: String = "",
        modalCloseText: String = "Close") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: modalTitle, message: modalMessage, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: modalCloseText, style: .default) { _ in
                alert.removeFromParent()
            }
            alert.addAction(alertAction)

            viewController.present(alert, animated: true)
        }
    }
}
