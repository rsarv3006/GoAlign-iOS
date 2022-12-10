//
//  ForgotPassword.swift
//  YourTurn
//
//  Created by rjs on 12/7/22.
//

import UIKit

class ForgotPasswordView: AuthViewController {

    var viewModel: ForgotPasswordVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            resetPasswordButton.setTitle(viewModel.resetPasswordButtonLabelString, for: .normal)
            emailInputField.placeholder = viewModel.resetEmailPlaceholderString
            navigationItem.title = viewModel.screenTitle
        }
    }

    private lazy var resetPasswordButton: BlueButton = {
        let button = BlueButton()
        return button
    }()
    
    private lazy var emailInputField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    override func configureView() {
        view.addSubview(emailInputField)
        emailInputField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 8, paddingRight: 8)
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.anchor(top: emailInputField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingRight: 32 )
        resetPasswordButton.addTarget(self, action: #selector(onResetPasswordButtonPressed), for: .touchUpInside)
    }
    
    @objc func onResetPasswordButtonPressed() {
        if let email = emailInputField.text, !email.isEmpty, email.contains("@") {
            viewModel?.requestPasswordReset(emailAddress: email, completion: { error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.showMessage(withTitle: "Uh Oh", message: "Error requesting password reset. Error: \(String(describing: error))")
                    }
                } else {
                    self.showMessage(withTitle: "Reset Requested", message: "Password reset has been requested. If you don't see it in your email please check your spam folder.")
                }
            })
        } else {
            showMessage(withTitle: "", message: "Invalid email address")
        }
    }

}
