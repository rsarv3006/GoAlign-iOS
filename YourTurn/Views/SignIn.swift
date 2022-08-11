//
//  SignIn.swift
//  YourTurn
//
//  Created by rjs on 7/22/22.
//

import UIKit
import Combine

class SignInScreen: AuthViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    weak var delegate: AuthScreenDelegate?
    
    var viewModel: SignInVM? {
        didSet {
            topLabel.text = viewModel?.signInLabelTextString
            buttonToSignUpScreen.setTitle(viewModel?.buttonTextGoToSignUp, for: .normal)
        }
    }
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "American Typewriter", size: 32)
        return label
    }()
    
    private let buttonToSignUpScreen: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(onButtonToSignUpScreenPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Helpers
    @objc func onButtonToSignUpScreenPressed() {
        delegate?.requestOtherAuthScreen(viewController: self)
    }
}

extension SignInScreen {
    func configureView() {
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        let leftSafeAnchor = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeAnchor = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeAnchor = view.safeAreaLayoutGuide.bottomAnchor
        
        view.addSubview(topLabel)
        topLabel.centerX(inView: view, topAnchor: topSafeAnchor, paddingTop: 32)
        
        view.addSubview(buttonToSignUpScreen)
        
        buttonToSignUpScreen.centerX(inView: view)
        buttonToSignUpScreen.anchor(bottom: bottomSafeAnchor, paddingBottom: 32)
        
    }
}
