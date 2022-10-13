//
//  TaskMoreInfoView.swift
//  YourTurn
//
//  Created by Robby on 10/7/22.
//

import UIKit

class TaskMoreInfoView: YtViewController {
    
    var viewModel: TaskMoreInfoVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelDidSet(viewModel: viewModel)
        }
    }
    
    // MARK: - UI Elements
    private lazy var creatorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var startDateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var endDateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var requiredCompletions: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var completionsCount: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var windowLengthLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var intervalBetweenWindows: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    override func configureView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        let stackView = UIStackView(arrangedSubviews: [creatorLabel, createdDateLabel, startDateLabel, endDateLabel, requiredCompletions, completionsCount, notesLabel, windowLengthLabel, intervalBetweenWindows])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.center(inView: view)
        
        stackView.setWidth(screenWidth * 0.75)
        stackView.setHeight(screenHeight * 0.6)
        
        stackView.backgroundColor = .gray
        stackView.layer.cornerRadius = 10
    }
    
    func onViewModelDidSet(viewModel: TaskMoreInfoVM) {
        creatorLabel.text = viewModel.creatorLabel
        createdDateLabel.text = viewModel.createdDateLabel
        startDateLabel.text = viewModel.startDateLabel
        endDateLabel.text = viewModel.endDateLabel
        requiredCompletions.text = viewModel.requiredCompletionsLabel
        completionsCount.text = viewModel.completionsCountLabel
        notesLabel.text = viewModel.notesLabel
        windowLengthLabel.text = viewModel.windowLengthLabel
        intervalBetweenWindows.text = viewModel.intervalBetweenWindowsLabel
    }
}
