//
//  TeamSettingsCellsDelegate.swift
//  YourTurn
//
//  Created by rjs on 12/23/22.
//

import UIKit

protocol TeamSettingsCellsDelegate: AnyObject {
    func requestHomeReloadFromCell()
    func requestRemoveTabViewFromCell()
    func requestShowLoaderFromCell(isVisible: Bool)
    func requestShowAlertFromCell(alert: UIAlertController)
    func requestShowMessageFromCell(withTitle: String, message: String)
    func requestShowModalFromCell(modal: UIViewController)
}
