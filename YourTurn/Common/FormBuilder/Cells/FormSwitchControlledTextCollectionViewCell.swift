//
//  FormSwitchControlledTextCollectionViewCell.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import UIKit
import Combine

class FormSwitchControlledTextCollectionViewCell: UICollectionViewCell {
    
    private var subscriptions = Set<AnyCancellable>()
    private var item: SwitchControlledTextFormComponent?
    private var indexPath: IndexPath?
    private(set) var subject = PassthroughSubject<(String, IndexPath), Never>()
    private(set) var reload = PassthroughSubject<String, Never>()
    
    private lazy var textFieldControlLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var textFieldControl: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    private lazy var txtField: UITextField = {
        let txtField = UITextField()
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
    
    private lazy var switchStackView: UIStackView = {
        let stackVw = UIStackView()
        stackVw.translatesAutoresizingMaskIntoConstraints = false
        stackVw.axis = .horizontal
        return stackVw
    }()
    
    func bind(_ item: FormComponent,
              at indexPath: IndexPath) {
        guard let item = item as? SwitchControlledTextFormComponent else { return }
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

private extension FormSwitchControlledTextCollectionViewCell {
    
    func setup(item: SwitchControlledTextFormComponent) {
        textFieldControlLabel.text = item.switchLabel
        
        textFieldControl.addTarget(self, action: #selector(onTextControlToggle(_:)), for: .valueChanged)
        
        setupCombineSubjects()
        
        // Setup
        txtField.delegate = self
        txtField.placeholder = item.placeholder
        txtField.keyboardType = item.keyboardType
        txtField.layer.borderColor = UIColor.systemGray5.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        
        // Layout
        
        contentView.addSubview(contentStackVw)
        
        contentStackVw.addArrangedSubview(switchStackView)
        
        switchStackView.addArrangedSubview(textFieldControlLabel)
        switchStackView.addArrangedSubview(textFieldControl)
        
        NSLayoutConstraint.activate([
            textFieldControlLabel.heightAnchor.constraint(equalToConstant: 44),
            textFieldControl.heightAnchor.constraint(equalToConstant: 44),
            
            txtField.heightAnchor.constraint(equalToConstant: 44),
            errorLbl.heightAnchor.constraint(equalToConstant: 22),
            contentStackVw.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentStackVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        
    }
    
    func manipulateErrorLabelVisibility(_ showHideVariant: ShowHideLabelVariant) {
        if showHideVariant == .hide {
            contentStackVw.removeArrangedSubview(errorLbl)
        } else {
            contentStackVw.addArrangedSubview(errorLbl)
        }
        self.reload.send("")
    }
    
    func manipulateTextFieldVisibility(_ showHideVariant: ShowHideLabelVariant) {
        if showHideVariant == .hide {
            txtField.isHidden = true
            contentStackVw.removeArrangedSubview(txtField)
        } else {
            txtField.isHidden = false
            contentStackVw.addArrangedSubview(txtField)
        }
        self.reload.send("")
    }
    
    @objc func onTextControlToggle(_ sender: UISwitch) {
        if sender.isOn {
            manipulateTextFieldVisibility(.show)
        } else {
            manipulateTextFieldVisibility(.hide)
        }
        self.reload.send("")
    }
}

// MARK: - Combine
extension FormSwitchControlledTextCollectionViewCell {
    func setupCombineSubjects() {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: txtField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] val in
                
                guard let self = self,
                      let indexPath = self.indexPath, let item = self.item else { return }
                
                if self.textFieldControl.isOn {
                    self.subject.send((val, indexPath))
                } else {
                    self.subject.send(("", indexPath))
                }
                
                
                do {
                    for validator in item.validations {
                        try validator.validate(val)
                    }
                    
                    self.txtField.valid()
                    if let errorLabelTextCount = self.errorLbl.text?.count, errorLabelTextCount > 0 {
                        self.manipulateErrorLabelVisibility(.hide)
                    }
                    self.errorLbl.text = ""
                    
                    
                } catch {
                    
                    self.txtField.invalid()
                    if let validationError = error as? ValidationError {
                        switch validationError {
                        case .custom(let message):
                            self.manipulateErrorLabelVisibility(.show)
                            self.errorLbl.text = message
                        }
                    }
                    Logger.log(logLevel: .Prod, name: Logger.Events.Form.Field.validationFailed, payload: ["error": error, "field": "switch_controlled_text"])
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UITextFieldDelegate
extension FormSwitchControlledTextCollectionViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
