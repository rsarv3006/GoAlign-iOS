//
//  GroupTasksTabView.swift
//  YourTurn
//
//  Created by rjs on 11/5/22.
//

import UIKit

private let cellReuseIdentifier = "TeamTasksTabViewTableCell"

class TeamTasksTabView: YtViewController {
    
    var viewModel: TeamTasksTabVM? {
        didSet {
            tasksTableView.reloadData()
        }
    }
    
    // MARK: UIElements
    private lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TeamTasksTabViewTableCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = 60
        return tableView
    }()
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TeamTasksTabViewTableCell
        if let task = viewModel?.team.tasks[indexPath.row] {
            cell.viewModel = TeamTasksTabViewCellVM(task: task)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let task = viewModel?.team.tasks[indexPath.row] {
            let taskViewVm = TaskViewVM(task: task)
            let taskView = TaskView()
            taskView.viewModel = taskViewVm
            self.present(taskView, animated: true)
        }
        return nil
    }
}
