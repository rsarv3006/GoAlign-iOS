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
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
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
    
    private lazy var modalView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var stackView: UIStackView?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    override func configureView() {
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        stackView = UIStackView(arrangedSubviews: [creatorLabel, createdDateLabel, startDateLabel, endDateLabel, requiredCompletions, completionsCount, notesLabel, windowLengthLabel, intervalBetweenWindows])
        
        guard let stackView = stackView else { return }
        stackView.axis = .vertical
        stackView.spacing = 8
        
        view.addSubview(modalView)
        modalView.center(inView: view)
        
        modalView.setWidth(screenWidth * 0.75)
        modalView.setHeight(screenHeight * 0.6)
        
        modalView.backgroundColor = .customBackgroundColor
        modalView.layer.cornerRadius = 10
        
        modalView.addSubview(titleLabel)
        titleLabel.anchor(top: modalView.topAnchor, left: modalView.leftAnchor, right: modalView.rightAnchor)
        titleLabel.textAlignment = .center
        
        modalView.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: modalView.leftAnchor, right: modalView.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8)
        
        modalView.addSubview(closeButton)
        closeButton.anchor(top: modalView.topAnchor, left: modalView.leftAnchor)
        
        closeButton.addTarget(self, action: #selector(onCloseButtonPressed), for: .touchUpInside)
    }
    
    func onViewModelDidSet(viewModel: TaskMoreInfoVM) {
        titleLabel.text = viewModel.titleLabel
        creatorLabel.text = viewModel.creatorLabel
        createdDateLabel.text = viewModel.createdDateLabel
        startDateLabel.text = viewModel.startDateLabel
        
        
        completionsCount.text = viewModel.completionsCountLabel
        
        windowLengthLabel.text = viewModel.windowLengthLabel
        intervalBetweenWindows.text = viewModel.intervalBetweenWindowsLabel
        
        if viewModel.isNotesLabelVisible {
            notesLabel.text = viewModel.notesLabel
        } else {
            stackView?.removeArrangedSubview(notesLabel)
        }
        
        if viewModel.isEndDateLabelVisible {
            endDateLabel.text = viewModel.endDateLabel
        } else {
            stackView?.removeArrangedSubview(endDateLabel)
        }
        
        if viewModel.isRequiredCompletionsLabelVisible {
            requiredCompletions.text = viewModel.requiredCompletionsLabel
        } else {
            stackView?.removeArrangedSubview(requiredCompletions)
        }
        
    }
    
    // MARK: - Actions
    
    @objc func onCloseButtonPressed() {
        self.dismiss(animated: true)
    }
}
