//
//  TeamUsersTabViewCell.swift
//  YourTurn
//
//  Created by rjs on 11/8/22.
//

import UIKit

class TeamUsersTabViewCell: UITableViewCell {
    
    var viewModel: TeamUsersTabViewCellVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelSet(viewModel: viewModel)
        }
    }
    
    // MARK: UI Elements
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configureView() {
        contentView.addSubview(userNameLabel)
        userNameLabel.fillSuperview()
    }
    
    private func onViewModelSet(viewModel: TeamUsersTabViewCellVM) {
        userNameLabel.text = viewModel.username
    }
}
