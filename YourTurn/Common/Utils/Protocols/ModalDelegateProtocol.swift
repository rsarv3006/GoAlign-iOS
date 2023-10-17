//
//  ModalDelegateProtocol.swift
//  YourTurn
//
//  Created by rjs on 8/18/22.
//

import Foundation
import UIKit

protocol ModalDelegate: AnyObject {
    func modalSentValue(viewController: ModalViewController, value: Any)
}
