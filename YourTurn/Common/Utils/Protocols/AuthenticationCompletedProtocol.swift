//
//  AuthenticationCompletedProtocol.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import UIKit

protocol AuthScreenDelegate: AnyObject {
    func authenticationDidComplete(viewController: AuthViewController)
    
    func requestOtherAuthScreen(viewController: AuthViewController)
    
    func requestInputCodeScreen(viewController: AuthViewController, loginRequestModel: LoginRequestModel)
}
