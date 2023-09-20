//
//  TeamInviteCellView.swift
//  YourTurn
//
//  Created by rjs on 8/29/22.
//

import Foundation
import UIKit

class TeamInviteCellView: UITableViewCell {
    
    var viewModel: TeamInviteCellVM? {
        didSet {
            teamNameLabel.text = viewModel?.teamNameLabel
            invitedByLabel.text = viewModel?.invitedByLabel
        }
    }
    
    private var areButtonsVisible: Bool = false
    
    // MARK: - UI Elements
    private lazy var teamNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()
    
    private lazy var invitedByLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customText
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellView() {
        contentView.backgroundColor = .customBackgroundColor
        contentView.addSubview(teamNameLabel)
        teamNameLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
        
        contentView.addSubview(invitedByLabel)
        invitedByLabel.anchor(top: teamNameLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingLeft: 8)
    }
    
}
