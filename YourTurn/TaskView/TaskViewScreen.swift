//
//  TaskView.swift
//  YourTurn
//
//  Created by Robby on 9/28/22.
//

import UIKit
import Combine

class TaskViewScreen: UIViewController {
    var subscriptions = Set<AnyCancellable>()
    
    private(set) var requestHomeReload = PassthroughSubject<Bool, Never>()
    
    var viewModel: TaskViewScreenVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            onViewModelDidSet(viewModel: viewModel)
        }
    }
    
    // MARK: UI Elements
    private lazy var taskSubView: TaskSubView = {
        let taskSubView = TaskSubView()
        return taskSubView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Helpers
    private func configureView() {        
        view.addSubview(taskSubView)
        taskSubView.fillSuperview()
    }
    
    
    private func onViewModelDidSet(viewModel: TaskViewScreenVM) {
        title = viewModel.contentTitle
        let subViewVM = TaskSubViewVM(task: viewModel.task)
        subViewVM.delegate = self
        taskSubView.viewModel = subViewVM
    }
}

extension TaskViewScreen: TaskSubViewVMDelegate {
    func requestHomeReloadFromSubView() {
        requestHomeReload.send(true)
    }
    
    func requestPopView() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func requestShowMessage(withTitle: String, message: String) {
        showMessage(withTitle: withTitle, message: message)
    }
    
    func requestPresentViewController(_ newVc: UIViewController) {
        present(newVc, animated: true)
    }
    
    
}
