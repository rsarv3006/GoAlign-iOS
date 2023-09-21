//
//  TeamSettingsDeleteTeamCell.swift
//  YourTurn
//
//  Created by rjs on 12/23/22.
//

import UIKit

class TeamSettingsDeleteTeamCell: UITableViewCell {
    
    var viewModel: TeamSettingsDeleteTeamCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            deleteTeamButton.setTitle(viewModel.deleteTeamButtonTitle, for: .normal)
            deleteTeamButton.titleLabel?.textColor = .systemBlue
        }
    }
    
    private lazy var deleteTeamButton: AlertButton = {
        let button = AlertButton()
        button.addTarget(self, action: #selector(onDeleteTeamPressed), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .customBackgroundColor
        contentView.addSubview(deleteTeamButton)
        deleteTeamButton.fillSuperview()
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
    
    @objc func onDeleteTeamPressed() {
        viewModel?.displayConfirmDeleteTeamModal()
    }
}
