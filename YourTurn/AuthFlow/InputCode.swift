//
//  InputCode.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 8/30/23.
//

import UIKit
import Combine

class InputCode: AuthViewController {
    var viewModel: InputCodeVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.inputCodeLabelTextString
            subtitleLabel.text = viewModel.inputCodeSubtitleString
            submitButton.setTitle(viewModel.submitButtonString, for: .normal)

            viewModel.inputCodeSubject.sink(receiveValue: { result in
                self.showLoader(false)
                switch result {
                case .failure(let error):
                    Logger.log(logLevel: .verbose, name: Logger.Events.Auth.signInFailed, payload: ["error": error])
                    let errorStringToDisplay = AuthenticationService.checkForStandardErrors(error: error)
                    AlertModalService.openAlert(viewController: self, modalMessage: errorStringToDisplay)
                case .success(let didAuthenticate):
                    if didAuthenticate {
                        self.delegate?.authenticationDidComplete(viewController: self)
                    }
                }
            }).store(in: &subscriptions)
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textColor = .customTitleText
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .customTitleText
        label.numberOfLines = -1
        return label
    }()

    let codeInputField: UITextField = {
        let codeInputField = UITextField()
        codeInputField.borderStyle = .roundedRect
        codeInputField.backgroundColor = .customBackgroundColor

        return codeInputField
    }()

    let submitButton: UIButton = {
        let btn = BlueButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.lightButtonText, for: .normal)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return btn
    }()

    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .customBackgroundColor
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    internal override func configureView() {
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)

        view.addSubview(subtitleLabel)
        subtitleLabel.centerX(inView: view, topAnchor: titleLabel.safeAreaLayoutGuide.bottomAnchor, paddingTop: 16)

        view.addSubview(codeInputField)
        codeInputField.centerX(inView: view, topAnchor: subtitleLabel.safeAreaLayoutGuide.bottomAnchor, paddingTop: 16)
        codeInputField.anchor(
            left: view.safeAreaLayoutGuide.leftAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingLeft: 8,
            paddingRight: 8)

        view.addSubview(submitButton)
        submitButton.centerX(inView: view, topAnchor: codeInputField.bottomAnchor, paddingTop: 16)
        submitButton.anchor(
            left: view.safeAreaLayoutGuide.leftAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingLeft: 8,
            paddingRight: 8)
        submitButton.addTarget(self, action: #selector(onSubmitPressed), for: .touchUpInside)
    }

    @objc func onSubmitPressed() {
        guard let textFieldInput = codeInputField.text, let viewModel else {
            self.showMessage(withTitle: "Uh Oh", message: "Code required.")
            return
        }

        let (isValid, error) = viewModel.validateTokenInputFromUser(code: textFieldInput)

        if !isValid {
            self.showMessage(withTitle: "Uh Oh", message: error)
        } else {
            viewModel.requestJwtFromServer(code: textFieldInput)
        }
    }
}
