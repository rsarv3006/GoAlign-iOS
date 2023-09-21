//
//  AllMembersCanAddTasksCell.swift
//  YourTurn
//
//  Created by rjs on 12/28/22.
//

import UIKit
import Combine

class TeamSettingsAllMembersCanAddTasksCell: UITableViewCell {
    
    var subscriptions = Set<AnyCancellable>()
    
    var viewModel: TeamSettingsAllMembersCanAddTasksCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            settingLabel.text = viewModel.switchTitle
            
            viewModel.settingPassThrough.sink { setting in
                DispatchQueue.main.async {
                    self.settingSwitch.isOn = setting
                }
            }.store(in: &subscriptions)
            
            viewModel.settingEnabledPassThrough.sink { isEnabled in
                DispatchQueue.main.async {
                    self.settingSwitch.isEnabled = isEnabled
                }
            }.store(in: &subscriptions)
        }
    }
    
    private lazy var settingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()
    
    private lazy var settingSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(onSettingToggle(_:)), for: .valueChanged)
        return sw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .customBackgroundColor
        let stack = UIStackView(arrangedSubviews: [settingLabel, settingSwitch])
        stack.axis = .horizontal
        
        contentView.addSubview(stack)
        stack.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
          let margins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
          contentView.frame = contentView.frame.inset(by: margins)
          contentView.layer.cornerRadius = 8
    }

    @objc func onSettingToggle(_ sender: UISwitch) {
        if sender.isOn {
            viewModel?.updateSetting(newSettingValue: true)
        } else {
            viewModel?.updateSetting(newSettingValue: false)
        }
    }
}
