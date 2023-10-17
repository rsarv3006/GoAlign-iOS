//
//  FormPasswordCollectionViewCell.swift
//  YourTurn
//
//  Created by rjs on 7/24/22.
//

import UIKit
import Combine

class FormPasswordCollectionViewCell: UICollectionViewCell {

    private var subscriptions = Set<AnyCancellable>()
    private var item: PasswordFormComponent?
    private var indexPath: IndexPath?
    private(set) var subject = PassthroughSubject<(String, IndexPath), Never>()
    private(set) var reload = PassthroughSubject<String, Never>()

    private lazy var passwordField: UITextField = {
        let txtField = UITextField()
        txtField.isSecureTextEntry = true
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .roundedRect
        txtField.backgroundColor = .clear
        return txtField
    }()

    private lazy var confirmPasswordField: UITextField = {
        let txtField = UITextField()
        txtField.isSecureTextEntry = true
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .roundedRect
        txtField.backgroundColor = .clear
        return txtField
    }()

    private lazy var errorLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.systemRed
        lbl.text = ""
        return lbl
    }()

    private lazy var contentStackVw: UIStackView = {
        let stackVw = UIStackView()
        stackVw.translatesAutoresizingMaskIntoConstraints = false
        stackVw.axis = .vertical
        stackVw.spacing = 6
        return stackVw
    }()

    func bind(_ item: FormComponent,
              at indexPath: IndexPath) {
        guard let item = item as? PasswordFormComponent else { return }
        self.indexPath = indexPath
        self.item = item
        setup(item: item)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
        self.item = nil
        self.indexPath = nil
        subscriptions = []
    }
}

private extension FormPasswordCollectionViewCell {

    func setup(item: PasswordFormComponent) {
        setUpListenerOnPasswordField(item: item)
        setUpListenerOnConfirmPasswordField(item: item)

        // Setup
        passwordField.delegate = self
        passwordField.placeholder = item.placeholder
        passwordField.layer.borderColor = UIColor.systemGray5.cgColor
        passwordField.layer.borderWidth = 1
        passwordField.layer.cornerRadius = 8

        confirmPasswordField.delegate = self
        confirmPasswordField.placeholder = item.confirmPlaceholder
        confirmPasswordField.layer.borderColor = UIColor.systemGray5.cgColor
        confirmPasswordField.layer.borderWidth = 1
        confirmPasswordField.layer.cornerRadius = 8
        // Layout

        contentView.addSubview(contentStackVw)

        contentStackVw.addArrangedSubview(passwordField)
        contentStackVw.addArrangedSubview(confirmPasswordField)

        NSLayoutConstraint.activate([
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 44),
            errorLbl.heightAnchor.constraint(equalToConstant: 22),
            contentStackVw.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentStackVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

    }

    func manipulateErrorLabel(_ showHideVariant: ShowHideLabelVariant) {
        if showHideVariant == .hide {
            contentStackVw.removeArrangedSubview(errorLbl)
        } else {
            contentStackVw.addArrangedSubview(errorLbl)
        }
        self.reload.send("")
    }

}

extension FormPasswordCollectionViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension FormPasswordCollectionViewCell {
    func setUpListenerOnPasswordField(item: PasswordFormComponent) {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] val in

                guard let self = self,
                      let indexPath = self.indexPath else { return }

                self.subject.send((val, indexPath))

                do {
                    for validator in item.validations {
                        try validator.validate(val)
                    }

                    if val != self.confirmPasswordField.text {
                        throw ValidationError.custom(message: "Passwords do not match.")
                    }

                    self.passwordField.valid()
                    if let errorLabelTextCount = self.errorLbl.text?.count, errorLabelTextCount > 0 {
                        self.manipulateErrorLabel(.hide)
                    }
                    self.errorLbl.text = ""

                } catch {

                    self.passwordField.invalid()
                    if let validationError = error as? ValidationError {
                        switch validationError {
                        case .custom(let message):
                            self.manipulateErrorLabel(.show)
                            self.errorLbl.text = message
                        }
                    }
                    Logger.log(
                        logLevel: .prod,
                        name: Logger.Events.Form.Field.validationFailed,
                        payload: ["error": error, "field": "password"])
                }
            }
            .store(in: &subscriptions)
    }

    func setUpListenerOnConfirmPasswordField(item: PasswordFormComponent) {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: confirmPasswordField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] val in

                guard let self = self,
                      let indexPath = self.indexPath else { return }

                self.subject.send((val, indexPath))

                do {
                    for validator in item.validations {
                        try validator.validate(val)
                    }

                    if val != self.passwordField.text {
                        throw ValidationError.custom(message: "Passwords do not match.")
                    }

                    self.passwordField.valid()
                    if let errorLabelTextCount = self.errorLbl.text?.count, errorLabelTextCount > 0 {
                        self.manipulateErrorLabel(.hide)
                    }
                    self.errorLbl.text = ""

                } catch {

                    self.passwordField.invalid()
                    if let validationError = error as? ValidationError {
                        switch validationError {
                        case .custom(let message):
                            self.manipulateErrorLabel(.show)
                            self.errorLbl.text = message
                        }
                    }
                    Logger.log(
                        logLevel: .prod,
                        name: Logger.Events.Form.Field.validationFailed,
                        payload: ["error": error, "field": "password"])
                }
            }
            .store(in: &subscriptions)
    }
}
