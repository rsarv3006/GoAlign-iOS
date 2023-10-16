//
//  IntervalPicker.swift
//  YourTurn
//
//  Created by rjs on 6/30/22.
//

import Foundation
import UIKit

protocol IntervalPickerDelegate {
    func onIntervalChange(intervalPicker: IntervalPicker, intervalObj: IntervalObject)
}

class IntervalPicker: UIView {
    // MARK: - Properties
    var delegate: IntervalPickerDelegate?
    
    var label: String?
    
    private var intervalObj = IntervalObject(1, .day)
    
    private let numberPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
        
        numberPicker.selectRow(0, inComponent: 0, animated: true)
        numberPicker.selectRow(2, inComponent: 1, animated: true)
    }
    
    init(frame: CGRect, interval: IntervalObject) {
        super.init(frame: frame)
        onInit()
        self.intervalObj = interval
        
        let indexForInterval = INTERVALSARRAY.firstIndex(of: interval.intervalUnit)
        
        numberPicker.selectRow(interval.intervalCount - 1, inComponent: 0, animated: true)
        numberPicker.selectRow(indexForInterval ?? 1, inComponent: 1, animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func onInit() {
        
        numberPicker.dataSource = self
        numberPicker.delegate = self
        
        addSubview(numberPicker)
        numberPicker.fillSuperview()
    }
    
    func convertStringToEnum(_ stringVal: String) -> IntervalVariant {
        return IntervalVariant.init(rawValue: stringVal)!
    }
}

extension IntervalPicker: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? 99 : INTERVALSARRAY.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
}

extension IntervalPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(row + 1)" : INTERVALSARRAY[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            intervalObj.intervalCount = row + 1
        } else {
            intervalObj.intervalUnit = INTERVALSARRAY[row]
        }
        
        delegate?.onIntervalChange(intervalPicker: self, intervalObj: intervalObj)
    }
}

extension IntervalPicker: FieldValidInvalidHandlers {
    func valid() {
        layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    func invalid() {
        layer.borderColor = UIColor.systemRed.cgColor
    }
}

