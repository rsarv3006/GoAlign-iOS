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
                    Logger.log(logLevel: .Verbose, name: Logger.Events.Auth.signInFailed, payload: ["error": error])
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
        label.font = UIFont(name: "American Typewriter", size: 32)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "American Typewriter", size: 16)
        return label
    }()
    
    let codeInputField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        return button
    }()
    
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
        codeInputField.anchor(left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 8, paddingRight: 8)
        
        view.addSubview(submitButton)
        submitButton.centerX(inView: view, topAnchor: codeInputField.bottomAnchor, paddingTop: 16)
        submitButton.addTarget(self, action: #selector(onSubmitPressed), for: .touchUpInside)
    }
    
    @objc func onSubmitPressed() {
        // TODO: client side validation for code
        guard let textFieldInput = codeInputField.text else {
            print("bad bad bad")
            return
        }
        viewModel?.requestJwtFromServer(code: textFieldInput)
    }
}
