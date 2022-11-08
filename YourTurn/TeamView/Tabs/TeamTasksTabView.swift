//
//  GroupTasksTabView.swift
//  YourTurn
//
//  Created by rjs on 11/5/22.
//

import UIKit

class TeamTasksTabView: YtViewController {
    
    var viewModel: TeamTasksTabVM? {
        didSet {
            tasksTableView.reloadData()
        }
    }
    
    // MARK: UIElements
    private lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TeamTasksTabViewTableCell.self, forCellReuseIdentifier: "TeamTasksTabViewTableCell")
        tableView.rowHeight = 60
        return tableView
    }()
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        configureView()
    }
    
    // MARK: Helpers
    override func configureView() {
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        view.addSubview(tasksTableView)
        tasksTableView.fillSuperview()
    }
}

extension TeamTasksTabView: UITableViewDelegate {}

extension TeamTasksTabView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.team.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamTasksTabViewTableCell", for: indexPath) as! TeamTasksTabViewTableCell
        let task = viewModel?.team.tasks[indexPath.row]
        if let task = task {
            cell.viewModel = TeamTasksTabViewCellVM(task: task)
        }
        return cell
    }
}
