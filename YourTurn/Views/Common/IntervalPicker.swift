//
//  IntervalPicker.swift
//  YourTurn
//
//  Created by rjs on 6/30/22.
//

import Foundation
import UIKit

enum IntervalVariant: String {
    case minute = "minute(s)"
    case hour = "hour(s)"
    case day = "day(s)"
    case week = "week(s)"
    case month = "month(s)"
    case year = "year(s)"
}

let INTERVALS_ARRAY = [IntervalVariant.minute, IntervalVariant.hour, IntervalVariant.day, IntervalVariant.week, IntervalVariant.month, IntervalVariant.year]

struct IntervalObject {
    var intervalNumber: Int = 1
    var intervalType: IntervalVariant = .day
    
    init(_ intervalNumber: Int, _ intervalType: IntervalVariant){
        self.intervalNumber = intervalNumber
        self.intervalType = intervalType
    }
    
    func toString() -> String {
        return "\(intervalNumber) - \(intervalType)"
    }
}

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
        
        numberPicker.dataSource = self
        numberPicker.delegate = self
        
        addSubview(numberPicker)
        numberPicker.fillSuperview()
        
        numberPicker.selectRow(0, inComponent: 0, animated: true)
        numberPicker.selectRow(2, inComponent: 1, animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func convertStringToEnum(_ stringVal: String) -> IntervalVariant {
        return IntervalVariant.init(rawValue: stringVal)!
    }
}

extension IntervalPicker: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? 99 : INTERVALS_ARRAY.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
}

extension IntervalPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(row + 1)" : INTERVALS_ARRAY[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            intervalObj.intervalNumber = row + 1
        } else {
            intervalObj.intervalType = INTERVALS_ARRAY[row]
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

