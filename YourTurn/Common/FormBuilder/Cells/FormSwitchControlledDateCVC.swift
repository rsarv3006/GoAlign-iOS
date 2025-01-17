//
//  FormSwitchControlledDateCollectionViewCell.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import UIKit
import Combine

class FormSwitchControlledDateCVC: UICollectionViewCell {

    private lazy var dateControlLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()

    private lazy var dateControl: UISwitch = {
        let dateControlSwitch = UISwitch()

        if item?.editValue != nil {
            dateControlSwitch.isOn = true
        }

        return dateControlSwitch
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = Date().advanced(by: TimeInterval(24 * 60 * 60))

        if let editDateValue = item?.editValue {
            datePicker.date = editDateValue
        }

        return datePicker
    }()

    private lazy var errorLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.systemRed
        lbl.text = " "
        return lbl
    }()

    private lazy var titleDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var contentStackVw: UIStackView = {
        let stackVw = UIStackView()
        stackVw.translatesAutoresizingMaskIntoConstraints = false
        stackVw.axis = .vertical
        stackVw.spacing = 8
        return stackVw
    }()

    private lazy var switchStackView: UIStackView = {
        let stackVw = UIStackView()
        stackVw.translatesAutoresizingMaskIntoConstraints = false
        stackVw.axis = .horizontal
        return stackVw
    }()

    private(set) var subject = PassthroughSubject<(Date?, IndexPath), Never>()
    private(set) var reload = PassthroughSubject<String, Never>()

    private var item: SwitchControlledDateFormComponent?
    private var indexPath: IndexPath?

    func bind(_ item: FormComponent,
              at indexPath: IndexPath) {
        guard let item = item as? SwitchControlledDateFormComponent else { return }
        self.item = item
        self.indexPath = indexPath
        setup(item: item)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
        item = nil
        indexPath = nil
    }
}

private extension FormSwitchControlledDateCVC {

    func setup(item: SwitchControlledDateFormComponent) {
        dateControlLabel.text = item.switchLabel

        dateControl.addTarget(self, action: #selector(onControlToggle(_:)), for: .valueChanged)

        titleLabel.text = item.title

        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePicker.datePickerMode = item.mode

        contentView.addSubview(contentStackVw)

        titleDateStackView.addArrangedSubview(titleLabel)
        titleDateStackView.addArrangedSubview(datePicker)

        contentStackVw.addArrangedSubview(switchStackView)

        switchStackView.addArrangedSubview(dateControlLabel)
        switchStackView.addArrangedSubview(dateControl)

        NSLayoutConstraint.activate([
            dateControlLabel.heightAnchor.constraint(equalToConstant: 44),
            dateControl.heightAnchor.constraint(equalToConstant: 44),

            contentStackVw.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentStackVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        if let indexPath = indexPath {
            self.subject.send((nil, indexPath))
        }

    }

    func manipulateDateFieldVisibility(_ showHideVariant: ShowHideLabelVariant) {
        if showHideVariant == .hide {
            titleDateStackView.isHidden = true
            contentStackVw.removeArrangedSubview(titleDateStackView)
        } else {
            titleDateStackView.isHidden = false
            contentStackVw.addArrangedSubview(titleDateStackView)
        }
        self.reload.send("")
    }

    @objc func onControlToggle(_ sender: UISwitch) {
        guard let indexPath = indexPath,
              item != nil else { return }

        if sender.isOn {
            manipulateDateFieldVisibility(.show)
            self.subject.send((datePicker.date, indexPath))
        } else {
            manipulateDateFieldVisibility(.hide)
            self.subject.send((nil, indexPath))
        }
        self.reload.send("")
    }

    @objc func datePickerChanged(picker: UIDatePicker) {

        guard let indexPath = indexPath,
              let item = item else { return }

        let selectedDate = datePicker.date
        if dateControl.isOn {
            self.subject.send((selectedDate, indexPath))
        } else {
            self.subject.send((nil, indexPath))
        }

        do {
            for validator in item.validations {
                try validator.validate(selectedDate)
            }

            if let errorLabelTextCount = self.errorLbl.text?.count, errorLabelTextCount > 0 {
                manipulateErrorLabel(.hide)
            }
            self.errorLbl.text = ""

        } catch {
            self.manipulateErrorLabel(.show)
            if let validationError = error as? ValidationError {
                switch validationError {
                case .custom(let message):
                    self.errorLbl.text = message
                }
            }
            Logger.log(
                logLevel: .prod,
                name: Logger.Events.Form.Field.validationFailed,
                payload: ["error": error, "field": "switch_controlled_date"])
        }
    }
}

// MARK: Dynamic Reload
extension FormSwitchControlledDateCVC {
    func manipulateErrorLabel(_ showHideVariant: ShowHideLabelVariant) {
        if showHideVariant == .hide {
            contentStackVw.removeArrangedSubview(errorLbl)
        } else {
            contentStackVw.addArrangedSubview(errorLbl)
        }
        self.reload.send("")
    }
}
