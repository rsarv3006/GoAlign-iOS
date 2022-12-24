//
//  TeamSettingsRemoveSelfFromTeamCell.swift
//  YourTurn
//
//  Created by rjs on 12/23/22.
//

import UIKit

class TeamSettingsLeaveTeamCell: UITableViewCell {
    
    var viewModel: TeamSettingsLeaveTeamCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            leaveTeamButton.setTitle(viewModel.leaveTeamButtonTitle, for: .normal)
        }
    }
    
    private lazy var leaveTeamButton: AlertButton = {
        let button = AlertButton()
        button.addTarget(self, action: #selector(onLeaveTeamPressed), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(leaveTeamButton)
        leaveTeamButton.fillSuperview()
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
          let margins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
          contentView.frame = contentView.frame.inset(by: margins)
          contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onLeaveTeamPressed() {
        viewModel?.displayRemoveSelfFromTeamModal()
    }
}
