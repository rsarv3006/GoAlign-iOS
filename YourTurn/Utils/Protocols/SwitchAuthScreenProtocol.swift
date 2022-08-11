//
//  SwitchAuthScreenProtocol.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import UIKit

protocol SwitchAuthScreen: AnyObject {
    func requestOtherAuthScreen(viewController: UIViewController)
}
