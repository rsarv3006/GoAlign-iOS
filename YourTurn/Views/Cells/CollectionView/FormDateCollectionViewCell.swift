//
//  FormDateCollectionViewCell.swift
//  YourTurn
//
//  Created by rjs on 7/7/22.
//

import UIKit
import Combine

class FormDateCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = Date().advanced(by: TimeInterval(24 * 60 * 60))
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
    
    private(set) var subject = PassthroughSubject<(Date, IndexPath), Never>()
    private(set) var reload = PassthroughSubject<String, Never>()
    
    private var item: DateFormComponent?
    private var indexPath: IndexPath?
    
    func bind(_ item: FormComponent,
              at indexPath: IndexPath) {
        guard let item = item as? DateFormComponent else { return }
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

private extension FormDateCollectionViewCell {
    
    func setup(item: DateFormComponent) {
        titleLabel.text = item.title
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)

        datePicker.datePickerMode = item.mode
        
        contentView.addSubview(contentStackVw)
        
        titleDateStackView.addArrangedSubview(titleLabel)
        titleDateStackView.addArrangedSubview(datePicker)
        
        contentStackVw.addArrangedSubview(titleDateStackView)

        NSLayoutConstraint.activate([
            contentStackVw.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentStackVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        
        if let indexPath = indexPath  {
            self.subject.send((datePicker.date, indexPath))
        }
        
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {

        guard let indexPath = indexPath,
              let item = item else { return }

        let selectedDate = datePicker.date
        self.subject.send((selectedDate, indexPath))

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
            
            print(error)
        }
    }
}

// MARK: Dynamic Reload
extension FormDateCollectionViewCell {
    func manipulateErrorLabel(_ showHideVariant: ShowHideLabelVariant) {
        if showHideVariant == .hide {
            contentStackVw.removeArrangedSubview(errorLbl)
        } else {
            contentStackVw.addArrangedSubview(errorLbl)
        }
        self.reload.send("")
    }
}
