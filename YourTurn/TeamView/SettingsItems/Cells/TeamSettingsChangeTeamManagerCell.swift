//
//  TeamSettingsChangeTeamManager.swift
//  YourTurn
//
//  Created by rjs on 12/23/22.
//

import UIKit

class TeamSettingsChangeTeamManagerCell: UITableViewCell {
    
    var viewModel: TeamSettingsChangeTeamManagerCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            changeTeamManagerButton.setTitle(viewModel.changeTeamManagerButtonTitle, for: .normal)
        }
    }
    
    private lazy var changeTeamManagerButton: BlueButton = {
        let button = BlueButton()
        button.addTarget(self, action: #selector(onChangeTeamManagerPressed), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .customBackgroundColor
        contentView.addSubview(changeTeamManagerButton)
        changeTeamManagerButton.fillSuperview()
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
    
    @objc func onChangeTeamManagerPressed() {
        viewModel?.displayChangeTeamManagerModal()
    }
}
