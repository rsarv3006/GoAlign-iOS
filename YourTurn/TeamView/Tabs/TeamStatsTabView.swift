//
//  GroupStatsTabView.swift
//  YourTurn
//
//  Created by rjs on 11/6/22.
//

import UIKit
import Combine

class TeamStatsTabView: YtViewController {
    var subscriptions = Set<AnyCancellable>()
    
    var viewModel: TeamStatsTabVM?
    
    private lazy var tabTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var totalNumberOfTasksLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var numberOfCompletedTaskEntriesLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var numberOfCompletedTasksLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var averageTasksPerUserLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var numberOfTaskEntriesLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        
        showLoader(true)
        configureFromViewModel()

    }
    
    private func configureFromViewModel() {
        guard let viewModel = viewModel else { return }
        tabTitle.text = viewModel.tabTitleString
        
        viewModel.reloadStats.sink { teamStatsResult in
            self.showLoader(false)
            switch teamStatsResult {
            case .success(_):
                self.setLabelTitlesFromTeamStats(viewModel: viewModel)
            case .failure(let error):
                Logger.log(logLevel: .Prod, name: Logger.Events.Team.Stats.fetchFailed, payload: ["error": error.localizedDescription])
                self.showMessage(withTitle: "Uh Oh", message: "Unexpected error fetching stats. \(error.localizedDescription)")
            }
        }.store(in: &subscriptions)
    }
    
    override func configureView() {
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        let leftSafeAnchor = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeAnchor = view.safeAreaLayoutGuide.rightAnchor
        
        view.addSubview(tabTitle)
        tabTitle.centerX(inView: view, topAnchor: topSafeAnchor)
        
        view.addSubview(totalNumberOfTasksLabel)
        totalNumberOfTasksLabel.anchor(top: tabTitle.bottomAnchor, left: leftSafeAnchor, right: rightSafeAnchor)
        
        view.addSubview(numberOfCompletedTaskEntriesLabel)
        numberOfCompletedTaskEntriesLabel.anchor(top: totalNumberOfTasksLabel.bottomAnchor, left: leftSafeAnchor, right: rightSafeAnchor)
        
        view.addSubview(numberOfCompletedTasksLabel)
        numberOfCompletedTasksLabel.anchor(top: numberOfCompletedTaskEntriesLabel.bottomAnchor, left: leftSafeAnchor, right: rightSafeAnchor)
        
        view.addSubview(averageTasksPerUserLabel)
        averageTasksPerUserLabel.anchor(top: numberOfCompletedTasksLabel.bottomAnchor, left: leftSafeAnchor, right: rightSafeAnchor)
        
        view.addSubview(numberOfTaskEntriesLabel)
        numberOfTaskEntriesLabel.anchor(top: averageTasksPerUserLabel.bottomAnchor, left: leftSafeAnchor, right: rightSafeAnchor)
    }
    
    // MARK: Helpers
    private func setLabelTitlesFromTeamStats(viewModel: TeamStatsTabVM) {
        DispatchQueue.main.async {
            self.totalNumberOfTasksLabel.text = viewModel.labelStrings.totalNumberOfTasks
            self.numberOfCompletedTaskEntriesLabel.text = viewModel.labelStrings.numberOfCompletedTaskEntries
            self.numberOfCompletedTasksLabel.text = viewModel.labelStrings.numberOfCompletedTasks
            self.averageTasksPerUserLabel.text = viewModel.labelStrings.averageTasksPerUser
            self.numberOfTaskEntriesLabel.text = viewModel.labelStrings.numberOfTaskEntries
        }
    }
}
