//
//  SignUp.swift
//  YourTurn
//
//  Created by rjs on 7/22/22.
//

import Foundation
import UIKit
import Combine

protocol SignUpScreenDelegate: AnyObject {
    func authenticationDidComplete(viewController: UIViewController)
}

class SignUpScreen: UIViewController {
    
    var viewModel: SignUpVM? {
        didSet {
            topLabel.text = viewModel?.welcomeLabelText
            buttonToSignInScreen.setTitle(viewModel?.buttonTextGoToSignIn, for: .normal)
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var formContentBuilder = SignUpFormContentBuilderImpl()
    private lazy var formCompLayout = FormCompositionalLayout()
    private lazy var dataSource = makeDataSource()
    
    weak var delegate: SignUpScreenDelegate?
    
    private lazy var collectionView: UICollectionView = {
        return FormCollectionView(frame: .zero, collectionViewLayout: formCompLayout.layout)
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "American Typewriter", size: 32)
        return label
    }()
    
    private let buttonToSignInScreen: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        setup()
        updateDataSource()
    }
    
}

private extension SignUpScreen {
    func setup() {
        formSubmissionSubscription()
        signUpCompletedSubscription()
        
        collectionView.dataSource = dataSource
        
        view.addSubview(topLabel)
        
        topLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: topLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 24)
        
        view.addSubview(buttonToSignInScreen)
        
        buttonToSignInScreen.centerX(inView: view)
        buttonToSignInScreen.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
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
            case is ButtonFormComponent:
                return self.buildFormButtonCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
            case is PasswordFormComponent:
                return self.buildFormPasswordCollectionViewCell(collectionView: collectionView, indexPath: indexPath, item: item)
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
            .sink { [weak self] completedForm in
                print(completedForm)
                if let self = self {
                    self.viewModel?.signUp(form: completedForm)
                }
            }
            .store(in: &subscriptions)
    }
    
    func signUpCompletedSubscription() {
        viewModel?.signUpSubject.sink(receiveCompletion: { (error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Uh Oh", message: "There was an issue signing up. \n Error: \(String(describing: error))", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Close", style: .default) { _ in
                    alert.removeFromParent()
                }
                alert.addAction(alertAction)
                
                self.present(alert, animated: true)
            }
            
        }, receiveValue: { user in
            if user != nil {
                self.delegate?.authenticationDidComplete(viewController: self)
            }
        })
        .store(in: &subscriptions)
    }
}

// MARK: - UICollectionViewCell builders
private extension SignUpScreen {
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
    
    func buildFormButtonCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormButtonCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonCollectionViewCell.cellId, for: indexPath) as! FormButtonCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] id in
                self?.formContentBuilder.validate()
            }.store(in: &self.subscriptions)
        
        cell.bind(item)
        return cell
    }
    
    func buildFormPasswordCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: FormComponent) -> FormPasswordCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormPasswordCollectionViewCell.cellId, for: indexPath) as! FormPasswordCollectionViewCell
        
        cell
            .subject
            .sink { [weak self] val, indexPath in
                self?.formContentBuilder.update(val: val, at: indexPath)
            }
            .store(in: &self.subscriptions)
        
        cell.bind(item, at: indexPath)
        return cell
    }
}
