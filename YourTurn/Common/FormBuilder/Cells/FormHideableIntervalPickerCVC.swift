//
//  FormHideableIntervalPickerCollectionViewCell.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import UIKit
import Combine

class FormHideableIntervalPickerCVC: UICollectionViewCell {
    private var item: HideableIntervalPickerFormComponent?
    private var indexPath: IndexPath?
    private var isIntervalPickerVisible = false

    private var subscriptions = Set<AnyCancellable>()
    private(set) var subject = PassthroughSubject<(IntervalObject, IndexPath), Never>()
    private(set) var reload = PassthroughSubject<String, Never>()

    private lazy var controlLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()

    private lazy var controlButton: BlueButton = {
        let button = BlueButton(type: .custom)
        button.setTitle("  1 - day(s)  ", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        if let editPickerValue = item?.editValue {
            button.setTitle("  \(editPickerValue.toString())  ", for: .normal)
        }

        return button
    }()

    private lazy var intervalPicker: IntervalPicker = {
        var intervalPicker = IntervalPicker(frame: .zero)

        if let editPickerValue = item?.editValue {
            intervalPicker = IntervalPicker(frame: .zero, interval: editPickerValue)
        }

        return intervalPicker
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

    private lazy var controlStackView: UIStackView = {
        let stackVw = UIStackView()
        stackVw.translatesAutoresizingMaskIntoConstraints = false
        stackVw.axis = .horizontal
        return stackVw
    }()

    func bind(_ item: FormComponent,
              at indexPath: IndexPath) {
        guard let item = item as? HideableIntervalPickerFormComponent else { return }
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

private extension FormHideableIntervalPickerCVC {
    func setup(item: HideableIntervalPickerFormComponent) {
        controlLabel.text = item.title

        controlButton.addTarget(self, action: #selector(onControlPress), for: .touchUpInside)

        intervalPicker.delegate = self

        contentView.addSubview(contentStackVw)

        contentStackVw.addArrangedSubview(controlStackView)

        controlStackView.addArrangedSubview(controlLabel)
        controlStackView.addArrangedSubview(controlButton)

        NSLayoutConstraint.activate([
            controlLabel.heightAnchor.constraint(equalToConstant: 44),
            controlButton.heightAnchor.constraint(equalToConstant: 44),

            intervalPicker.heightAnchor.constraint(equalToConstant: 100),
            errorLbl.heightAnchor.constraint(equalToConstant: 22),
            contentStackVw.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentStackVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        if let indexPath = indexPath {
            self.subject.send((IntervalObject(1, .day), indexPath))
        }

    }

    @objc func onControlPress() {
        if isIntervalPickerVisible == true {
            self.manipulateFieldVisibility(.hide)
            isIntervalPickerVisible = false
        } else {
            self.manipulateFieldVisibility(.show)
            isIntervalPickerVisible = true
        }
    }
}

extension FormHideableIntervalPickerCVC: FieldVisibilityHandlers {
    func manipulateErrorLabelVisibility(_ showHideVariant: ShowHideLabelVariant) {
        if showHideVariant == .hide {
            contentStackVw.removeArrangedSubview(errorLbl)
        } else {
            contentStackVw.addArrangedSubview(errorLbl)
        }
        self.reload.send("")
    }

    func manipulateFieldVisibility(_ showHideVariant: ShowHideLabelVariant) {
        if showHideVariant == .hide {
            intervalPicker.isHidden = true
            contentStackVw.removeArrangedSubview(intervalPicker)
        } else {
            intervalPicker.isHidden = false
            contentStackVw.addArrangedSubview(intervalPicker)
        }
        self.reload.send("")
    }
}

// MARK: - IntervalPickerDelegate
extension FormHideableIntervalPickerCVC: IntervalPickerDelegate {
    func onIntervalChange(intervalPicker: IntervalPicker, intervalObj: IntervalObject) {
        sendCombineEvent(for: intervalPicker, with: intervalObj)
        controlButton.setTitle("  \(intervalObj.toString())  ", for: .normal)
    }
}

// MARK: - Combine
extension FormHideableIntervalPickerCVC {
    func sendCombineEvent(for intervalPicker: IntervalPicker, with intervalObj: IntervalObject) {
        guard let indexPath = self.indexPath, let item = self.item else { return }

        self.subject.send((intervalObj, indexPath))

        do {
            for validator in item.validations {
                try validator.validate(intervalObj)
            }

            self.intervalPicker.valid()
            if let errorLabelTextCount = self.errorLbl.text?.count, errorLabelTextCount > 0 {
                self.manipulateErrorLabelVisibility(.hide)
            }
            self.errorLbl.text = ""

        } catch {
            self.intervalPicker.invalid()
            if let validationError = error as? ValidationError {
                switch validationError {
                case .custom(let message):
                    self.manipulateErrorLabelVisibility(.show)
                    self.errorLbl.text = message
                }
            }
            Logger.log(
                logLevel: .prod,
                name: Logger.Events.Form.Field.validationFailed,
                payload: ["error": error, "field": "hideable_interval_picker"])
        }
    }
}
