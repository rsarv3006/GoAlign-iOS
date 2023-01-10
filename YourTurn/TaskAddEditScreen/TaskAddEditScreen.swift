//
//  TaskAddEditScreen.swift
//  YourTurn
//
//  Created by rjs on 6/26/22.
//

import UIKit
import Combine

protocol TaskAddEditScreenDelegate {
    func onTaskScreenComplet(viewController: UIViewController)
}

class TaskAddEditScreen: UIViewController {
    // MARK: - Properties
    var delegate: TaskAddEditScreenDelegate?
    
    var viewModel: TaskAddEditScreenVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            if let taskToEdit = viewModel.taskToEdit {
                formContentBuilder = TaskAddEditFormContentBuilderImpl(fromTask: taskToEdit)
            }
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var formContentBuilder = TaskAddEditFormContentBuilderImpl()
    private lazy var formCompLayout = FormCompositionalLayout()
    private lazy var dataSource = makeDataSource()
    
    private lazy var collectionView: UICollectionView = {
        return FormCollectionView(frame: .zero, collectionViewLayout: formCompLayout.layout)
    }()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        setup()
        updateDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.screenTitleLabelString
        view.backgroundColor = .systemBackground
    }
}

private extension TaskAddEditScreen {
    func setup() {
        formSubmissionSubscription()
        
        collectionView.dataSource = dataSource
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<FormSectionComponent, FormComponent> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellId, for: indexPath)
                return cell
            }
            
            switch item {
            case is TextFormComponent:
                return self.buildFormTextCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            case is DateFormComponent:
                return self.buildFormDateCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            case is ButtonFormComponent:
                return self.buildFormButtonCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            case is SwitchControlledTextFormComponent:
                return self.buildFormSwitchControlledTextCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            case is SwitchControlledDateFormComponent:
                return self.buildFormSwitchControlledDateCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            case is HideableIntervalPickerFormComponent:
                return self.buildFormHideableIntervalPickerCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            case is ModalFormComponent:
                return self.buildFormModalCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            case is TextBoxFormComponent:
                return self.buildFormTextBoxCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            default:
                return self.buildDefaultCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
            }
        }
    }
    
    func updateDataSource(animated: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            var snapshot = NSDiffableDataSourceSnapshot<FormSectionComponent, FormComponent>()
            
            let formSections = self.formContentBuilder.formContent
            snapshot.appendSections(formSections)
            formSections.forEach { snapshot.appendItems($0.items, toSection: $0) }
            
            self.dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }
    
    func formSubmissionSubscription() {
        formContentBuilder
            .formSubmission
            .throttle(for: .seconds(2.0), scheduler: RunLoop.current, latest: false)
            .sink { result in
                switch result {
                case .failure(let error):
                    print("ERROR IN TASK CREATION PLACEHOLDER")
                    print(error)
                case .success(let createTaskDto):
                    self.viewModel?.onTaskSubmit(viewController: self, taskForm: createTaskDto)
                }
            }.store(in: &subscriptions)
        
        formContentBuilder.formSubmissionUpdate.throttle(for: .seconds(2.0), scheduler: RunLoop.current, latest: false)
            .sink { result in
                switch result {
                case .failure(let error):
                    print("ERROR IN TASK CREATION PLACEHOLDER")
                    print(error)
                case .success(let updateTaskDto):
                    self.viewModel?.onTaskUpdate(viewController: self, taskForm: updateTaskDto)
                }
            }.store(in: &subscriptions)
    }
}

// MARK: - UICollectionViewCell builders
private extension TaskAddEditScreen {
    func buildDefaultCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellId, for: indexPath)
        return cell
    }
    
    func buildFormTextCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormTextCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTextCollectionViewCell.cellId, for: indexPath) as! FormTextCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] val, indexPath in
                self?.formContentBuilder.update(val: val, at: indexPath)
            }
            .store(in: &self.subscriptions)
        
        cell.reload.sink { [weak self] _ in
            self?.updateDataSource()
        }.store(in: &self.subscriptions)
        
        cell.bind(item, at: indexPath)
        return cell
    }
    
    func buildFormTextBoxCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormTextBoxCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTextBoxCollectionViewCell.cellId, for: indexPath) as! FormTextBoxCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] val, indexPath in
                self?.formContentBuilder.update(val: val, at: indexPath)
            }
            .store(in: &self.subscriptions)
        
        cell.reload.sink { [weak self] _ in
            self?.updateDataSource()
        }.store(in: &self.subscriptions)
        
        cell.bind(item, at: indexPath)
        return cell
    }
    
    func buildFormDateCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormDateCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormDateCollectionViewCell.cellId, for: indexPath) as! FormDateCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] val, indexPath in
                self?.formContentBuilder.update(val: val, at: indexPath)
            }
            .store(in: &self.subscriptions)
        
        cell.reload.sink { [weak self] _ in
            self?.updateDataSource()
        }.store(in: &self.subscriptions)
        
        cell.bind(item, at: indexPath)
        return cell
    }
    
    func buildFormButtonCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormButtonCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonCollectionViewCell.cellId, for: indexPath) as! FormButtonCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] id in
                self?.showLoader(true)
                self?.formContentBuilder.validate()
            }.store(in: &self.subscriptions)
        
        cell.bind(item)
        return cell
    }
    
    func buildFormSwitchControlledTextCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormSwitchControlledTextCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormSwitchControlledTextCollectionViewCell.cellId, for: indexPath) as! FormSwitchControlledTextCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] val, indexPath in
                self?.formContentBuilder.update(val: val, at: indexPath)
            }
            .store(in: &self.subscriptions)
        
        cell.reload.sink { [weak self] _ in
            self?.updateDataSource()
        }.store(in: &self.subscriptions)
        
        cell.bind(item, at: indexPath)
        return cell
    }
    
    func buildFormSwitchControlledDateCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormSwitchControlledDateCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormSwitchControlledDateCollectionViewCell.cellId, for: indexPath) as! FormSwitchControlledDateCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] val, indexPath in
                self?.formContentBuilder.update(val: val as Any, at: indexPath)
            }
            .store(in: &self.subscriptions)
        
        cell.reload.sink { [weak self] _ in
            self?.updateDataSource()
        }.store(in: &self.subscriptions)
        
        cell.bind(item, at: indexPath)
        return cell
    }
    
    func buildFormHideableIntervalPickerCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormHideableIntervalPickerCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormHideableIntervalPickerCollectionViewCell.cellId, for: indexPath) as! FormHideableIntervalPickerCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] val, indexPath in
                self?.formContentBuilder.update(val: val as Any, at: indexPath)
            }
            .store(in: &self.subscriptions)
        
        cell.reload.sink { [weak self] _ in
            self?.updateDataSource()
        }.store(in: &self.subscriptions)
        
        cell.bind(item, at: indexPath)
        return cell
    }
    
    func buildFormModalCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormModalCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormModalCollectionViewCell.cellId, for: indexPath) as! FormModalCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] val, indexPath in
                self?.formContentBuilder.update(val: val, at: indexPath)
            }
            .store(in: &subscriptions)
        
        cell.reload.sink { [weak self] _ in
            self?.updateDataSource()
        }.store(in: &self.subscriptions)
        
        cell.openModal
            .sink { modalView in
                DispatchQueue.main.async {
                    
                    modalView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    self.present(modalView, animated: true)
                }
            }
            .store(in: &subscriptions)
        
        cell.bind(item, at: indexPath)
        return cell
    }
}
