//
//  TaskAddEditScreen.swift
//  YourTurn
//
//  Created by rjs on 6/26/22.
//

import Foundation
import UIKit

//@Args('taskName') taskName: string,
//@Args('notes') notes: string,
//@Args('startDate') startDate: Date,
//@Args('requiredCompletionsNeeded') requiredCompletionsNeeded: number,
//@Args('intervalBetweenWindows') intervalBetweenWindows: number,
//@Args('windowLength') windowLength: number,
//@Args('teamId') teamId: string,
//@Args('assignedUserId') assignedUserId: string,
//@Args('creatorUserId') creatorUserId: string,
//@Args('endDate') endDate?: Date,

class TaskAddEditScreen: UIViewController {
    // MARK: - Properties
    var viewModel: TaskAddEditScreenVM?
    
    
    // MARK: - Properties - Static Labels
    private var taskNameTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var startDateTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    // MARK: - Properties - User Input
    private var taskNameInputField: UITextField = {
        let input = UITextField()
        return input
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Helpers
    private func configureView() {
        self.title = viewModel?.screenTitleLabelString
    }
}
