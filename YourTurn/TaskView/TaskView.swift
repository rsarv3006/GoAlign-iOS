//
//  TaskView.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import UIKit

class TaskView: UIViewController {
    
    var viewModel: TaskVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            title = viewModel.contentTitle
            assignedUserLabel.text = viewModel.assignedUserString
            assignedTeamLabel.text = viewModel.assignedTeamString
            taskHistoryTable.reloadData()
        }
    }
    
    // MARK: UI Elements
    private lazy var assignedUserLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var assignedTeamLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var taskHistoryTable: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    func configureView() {
        
    }
}
