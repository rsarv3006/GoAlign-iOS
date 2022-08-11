//
//  AuthViewController.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import UIKit

enum AuthScreenIdVariant {
    case SignIn
    case SignUp
}

class AuthViewController: UIViewController {
    private(set) var screenId: AuthScreenIdVariant? = nil
    
    func setScreenId(screenId : AuthScreenIdVariant) {
        self.screenId = screenId
    }
}
