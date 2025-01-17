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
        view.backgroundColor = .customBackgroundColor
        super.viewDidLoad()
        configureRootView()
    }

    func configureRootView() {
        showLoader(true)
        Task {
            defer {
                showLoader(false)
            }

            do {
                _ = try await AppState.getInstance().getAccessToken()
                goHome()
            } catch {
                goSignUp()
            }
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
            controller.setScreenId(screenId: .signUp)
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
            controller.setScreenId(screenId: .signIn)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: false, completion: nil)
        }
    }

    func goInputCode(viewController: AuthViewController, loginRequestModel: LoginRequestModel) {
        DispatchQueue.main.async {
            let controller = InputCode()
            controller.delegate = self
            let viewModel = InputCodeVM(loginRequestModel: loginRequestModel)
            controller.viewModel = viewModel
            viewController.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
// MARK: - AuthScreenDelegate
extension RootController: AuthScreenDelegate {
    func requestOtherAuthScreen(viewController: AuthViewController) {
        self.dismiss(animated: true)
        if viewController.screenId == .signUp {
            goSignIn()
        } else if viewController.screenId == .signIn {
            goSignUp()
        }
    }

    func authenticationDidComplete(viewController: AuthViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.goHome()
        }
    }

    func requestInputCodeScreen(viewController: AuthViewController, loginRequestModel: LoginRequestModel) {
        DispatchQueue.main.async {
            self.goInputCode(viewController: viewController, loginRequestModel: loginRequestModel)
        }
    }
}
