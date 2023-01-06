//
//  TeamTaskModal.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/4/23.
//

import UIKit

class TeamTaskModal: YtViewController {

    var viewModel: TeamTaskModalVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.contentTitle
            configureTaskSubViewVM(modalViewModel: viewModel)
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
    
    private lazy var taskSubView: TaskSubView = {
        return TaskSubView()
    }()
    
    // MARK: - Lifecycle
    override func configureView() {
        super.configureView()
        view.backgroundColor = .systemBackground
        
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: topSafeAnchor, paddingTop: 12)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: topSafeAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        closeButton.addTarget(self, action: #selector(onCloseButtonPressed), for: .touchUpInside)
        
        view.addSubview(taskSubView)
        taskSubView.anchor(top: closeButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    // MARK: - Helpers
    @objc func onCloseButtonPressed() {
        self.dismiss(animated: true)
    }
    
    private func configureTaskSubViewVM(modalViewModel: TeamTaskModalVM) {
        let subViewVM = TaskSubViewVM(task: modalViewModel.task)
        subViewVM.delegate = self
        taskSubView.viewModel = subViewVM
    }
}

extension TeamTaskModal: TaskSubViewVMDelegate {
    func requestHomeReloadFromSubView() {
        viewModel?.requestRefreshTeam.send(true)
    }
    
    func requestPopView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func requestShowMessage(withTitle: String, message: String) {
        showMessage(withTitle: withTitle, message: message)
    }
    
    func requestPresentViewController(_ newVc: UIViewController) {
        present(newVc, animated: true)
    }
}
