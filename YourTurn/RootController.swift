//
//  RootNavigationController.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import Foundation
import UIKit
import Combine

class RootController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
    }
    
    func configureRootView() {
        if !AuthenticationService.doesCurrentUserExist() {
            goSignUp()
        } else {
            goHome()
        }
    }
}

// MARK: - Navigation Functions
extension RootController {
    func goHome() {
        DispatchQueue.main.async {
            let homeScreenController = HomeScreen()
            homeScreenController.viewModel = HomeScreenVM()
            
            homeScreenController.logoutEventSubject.sink { _ in
                AuthenticationService.signOut()
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.goSignUp()
                }

            }.store(in: &self.subscriptions)
            
            self.dismiss(animated: true)
            let nav = UINavigationController(rootViewController: homeScreenController)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: false, completion: nil)
        }
    }
    
    func goSignUp() {
        DispatchQueue.main.async {
            let controller = SignUpScreen()
            let signUpVM = SignUpVM()
            controller.viewModel = signUpVM
            controller.delegate = self
            controller.setScreenId(screenId: .SignUp)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: false, completion: nil)
        }
    }
    
    func goSignIn() {
        DispatchQueue.main.async {
            let controller = SignInScreen()
            let signInVM = SignInVM()
            controller.viewModel = signInVM
            controller.delegate = self
            controller.setScreenId(screenId: .SignIn)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: false, completion: nil)
        }
    }
}
// MARK: - AuthScreenDelegate
extension RootController: AuthScreenDelegate {
    func requestOtherAuthScreen(viewController: AuthViewController) {
        self.dismiss(animated: true)
        if viewController.screenId == .SignUp {
            goSignIn()
        } else if viewController.screenId == .SignIn {
            goSignUp()
        }
        
    }
    
    func authenticationDidComplete(viewController: AuthViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.goHome()
        }
    }
}
