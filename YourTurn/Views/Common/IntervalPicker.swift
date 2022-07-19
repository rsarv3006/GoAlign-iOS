//
//  IntervalPicker.swift
//  YourTurn
//
//  Created by rjs on 6/30/22.
//

import Foundation
import UIKit

let INTERVALS = ["minute(s)", "hour(s)", "day(s)", "weeknight(s)", "fortnight(s)", "month(s)", "year(s)"]

struct IntervalObject {
    let intervalNumber: Int
    let intervalType: String
}

protocol IntervalPickerDelegate {
    func onIntervalChange(intervalPicker: IntervalPicker, intervalObj: IntervalObject)
}

// TODO: - Add passthroughsubject or delegate
class IntervalPicker: UIView {
    // MARK: - Properties
    var delegate: IntervalPickerDelegate?
    
    var label: String?
    
    private var intervalNumber = 0
    private var intervalType = INTERVALS[0]
    
    private let numberPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        print("DEBUG: HI FROM INTERVALPICKER")
        super.init(frame: frame)
        
        numberPicker.dataSource = self
        numberPicker.delegate = self
        
        addSubview(numberPicker)
        numberPicker.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IntervalPicker: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 99
        } else {
            return INTERVALS.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
}

extension IntervalPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row + 1)"
        } else {
            return INTERVALS[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            intervalNumber = row + 1
        } else {
            intervalType = INTERVALS[row]
        }
        
        delegate?.onIntervalChange(intervalPicker: self, intervalObj: IntervalObject(intervalNumber: intervalNumber, intervalType: intervalType))
    }
}
