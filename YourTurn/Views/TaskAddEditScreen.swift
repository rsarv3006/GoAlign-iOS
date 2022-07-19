//
//  TaskAddEditScreen.swift
//  YourTurn
//
//  Created by rjs on 6/26/22.
//

import Foundation
import UIKit
import Combine

//@Args('taskName') taskName: string,
//@Args('startDate') startDate: Date,
//@Args('endDate') endDate?: Date,
//@Args('requiredCompletionsNeeded') requiredCompletionsNeeded: number,
//@Args('intervalBetweenWindows') intervalBetweenWindows: number,
//@Args('windowLength') windowLength: number,
//@Args('teamId') teamId: string,
//@Args('assignedUserId') assignedUserId: string,
//@Args('creatorUserId') creatorUserId: string,
//@Args('notes') notes: string,

private let TOP_PADDING: CGFloat = 12

enum RequiredCompletionsAnchorPoint {
    case endDateInput
    case endDateLabelRow
}

class TaskAddEditScreen: UIViewController {
    // MARK: - Properties
    var viewModel: TaskAddEditScreenVM?
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var formContentBuilder = TaskAddEditFormContentBuilderImpl()
    private lazy var formCompLayout = FormCompositionalLayout()
    private lazy var dataSource = makeDataSource()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: formCompLayout.layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellId)
        cv.register(FormButtonCollectionViewCell.self, forCellWithReuseIdentifier: FormButtonCollectionViewCell.cellId)
        cv.register(FormTextCollectionViewCell.self, forCellWithReuseIdentifier: FormTextCollectionViewCell.cellId)
        cv.register(FormDateCollectionViewCell.self, forCellWithReuseIdentifier: FormDateCollectionViewCell.cellId)
        return cv
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
    }
    
    // MARK: - Helpers
}

// MARK: - IntervalPickerDelegate
extension TaskAddEditScreen: IntervalPickerDelegate {
    func onIntervalChange(intervalPicker: IntervalPicker, intervalObj: IntervalObject) {
        
        print("Num: \(intervalObj.intervalNumber) - Type: \(intervalObj.intervalType)")
    }
}

private extension TaskAddEditScreen {
    func setup() {
        
        formSubmissionSubscription()
        
        collectionView.dataSource = dataSource
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<FormSectionComponent, FormComponent> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellId, for: indexPath)
                return cell
            }
            
            switch item {
            case is TextFormComponent:
                print("DEBUG: Hi From Text Cell")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTextCollectionViewCell.cellId, for: indexPath) as! FormTextCollectionViewCell
                
                cell
                    .subject
                    .sink { [weak self] val, indexPath in
                        print("DEBUG: Hi From Text Cell passthroughsubject")
                        self?.formContentBuilder.update(val: val, at: indexPath)
                    }
                    .store(in: &self.subscriptions)
                cell.bind(item, at: indexPath)
                return cell
            case is DateFormComponent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormDateCollectionViewCell.cellId, for: indexPath) as! FormDateCollectionViewCell
                
                cell
                    .subject
                    .sink { [weak self] val, indexPath in
                        self?.formContentBuilder.update(val: val, at: indexPath)
                    }
                    .store(in: &self.subscriptions)
                
                cell.bind(item, at: indexPath)
                return cell
            case is ButtonFormComponent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonCollectionViewCell.cellId, for: indexPath) as! FormButtonCollectionViewCell
                
                cell
                    .subject
                    .sink { [weak self] id in
                        self?.formContentBuilder.validate()
                    }.store(in: &self.subscriptions)
                
                cell.bind(item)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellId, for: indexPath)
                return cell
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
}

extension TaskAddEditScreen {
    func formSubmissionSubscription() {
        formContentBuilder
            .formSubmission
            .sink { [weak self] val in
                print(val)
            }
            .store(in: &subscriptions)
    }
}
