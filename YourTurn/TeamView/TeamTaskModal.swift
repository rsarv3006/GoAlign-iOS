//
//  TeamTaskModal.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/4/23.
//

import UIKit
import Combine

class TeamTaskModal: YtViewController {
    
    var subscriptions = Set<AnyCancellable>()
    
    var viewModel: TeamTaskModalVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.contentTitle
            configureTaskSubViewVM(modalViewModel: viewModel)
            
            viewModel.isUserTeamManager.sink { isUserTeamManager in
                DispatchQueue.main.async {
                    if isUserTeamManager && !viewModel.isTaskComplete {
                        self.editButton.isHidden = false
                        self.deleteButton.isHidden = false
                    } else {
                        self.editButton.isHidden = true
                        self.deleteButton.isHidden = true
                    }
                }
            }.store(in: &subscriptions)
            
            viewModel.resetView.sink { error in
                if let error = error {
                    self.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.configureTaskSubViewVM(modalViewModel: viewModel)
                        self.titleLabel.text = viewModel.contentTitle
                    }
                }
            }.store(in: &subscriptions)
        }
    }
    
    // MARK: - UI Elements
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        let addImage = UIImage(systemName: "pencil.circle", withConfiguration: configuration)
        button.setImage(addImage, for: .normal)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        let addImage = UIImage(systemName: "trash.circle", withConfiguration: configuration)
        button.setImage(addImage, for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .customTitleText
        return label
    }()
    
    private lazy var taskSubView: TaskSubView = {
        return TaskSubView()
    }()
    
    // MARK: - Lifecycle
    override func configureView() {
        super.configureView()
        view.backgroundColor = .customBackgroundColor
        
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: topSafeAnchor, paddingTop: 12)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: topSafeAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 12)
        closeButton.addTarget(self, action: #selector(onCloseButtonPressed), for: .touchUpInside)
        
        view.addSubview(editButton)
        editButton.anchor(top: topSafeAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 48)
        editButton.addTarget(self, action: #selector(onEditButtonPressed), for: .touchUpInside)
        
        view.addSubview(deleteButton)
        deleteButton.anchor(top: topSafeAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        deleteButton.addTarget(self, action: #selector(onDeleteButtonPressed), for: .touchUpInside)
        
        view.addSubview(taskSubView)
        taskSubView.anchor(top: closeButton.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    // MARK: - Helpers
    @objc func onCloseButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func onEditButtonPressed() {
        guard let task = viewModel?.task else { return }
        let taskAddEditScreenVm = TaskAddEditScreenVM(fromTask: task)
        let taskAddEditScreen = TaskAddEditScreen()
        
        taskAddEditScreenVm.requestReload.sink { _ in
            self.viewModel?.refetchTeam()
            self.viewModel?.requestRefreshTeam.send(true)
        }.store(in: &subscriptions)
        
        taskAddEditScreen.viewModel = taskAddEditScreenVm
        self.present(taskAddEditScreen, animated: true)
    }
    
    @objc func onDeleteButtonPressed() {
        guard let task = viewModel?.task else { return }
        
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            Task {
                do {
                    self.showLoader(true)
                    try await self.viewModel?.deleteTask()
                    self.viewModel?.requestRefreshTeam.send(true)
                    self.requestPopView()
                    self.requestHomeReloadFromSubView()
                    self.showLoader(false)
                } catch {
                    self.showLoader(false)
                    self.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
                    
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
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
