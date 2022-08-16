//
//  SignIn.swift
//  YourTurn
//
//  Created by rjs on 7/22/22.
//

import UIKit
import Combine

class SignInScreen: AuthViewController {
    
    var viewModel: SignInVM? {
        didSet {
            topLabel.text = viewModel?.signInLabelTextString
            buttonToSignUpScreen.setTitle(viewModel?.buttonTextGoToSignUp, for: .normal)
        }
    }
    
    private lazy var formContentBuilder = SignInFormContentBuilderImpl()
    private lazy var dataSource = makeDataSource()
    
    // MARK: - UI Elements
    private let buttonToSignUpScreen: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        configureCollectionView()
        configureView()
        configureInteractables()
    }
    
    // MARK: - Helpers
    @objc func onButtonToSignUpScreenPressed() {
        delegate?.requestOtherAuthScreen(viewController: self)
    }
}

private extension SignInScreen {
    func configureView() {
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        let leftSafeAnchor = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeAnchor = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeAnchor = view.safeAreaLayoutGuide.bottomAnchor
        
        view.addSubview(topLabel)
        topLabel.centerX(inView: view, topAnchor: topSafeAnchor, paddingTop: 32)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: topLabel.bottomAnchor, left: leftSafeAnchor, bottom: bottomSafeAnchor, right: rightSafeAnchor, paddingTop: 24)
        
        view.addSubview(buttonToSignUpScreen)
        buttonToSignUpScreen.centerX(inView: view)
        buttonToSignUpScreen.anchor(bottom: bottomSafeAnchor, paddingBottom: 32)
        
    }
    
    func configureInteractables() {
        buttonToSignUpScreen.addTarget(self, action: #selector(onButtonToSignUpScreenPressed), for: .touchUpInside)
    }
}

// MARK: - Form Building
private extension SignInScreen {
    func configureCollectionView() {
        collectionView.dataSource = dataSource
        
        updateDataSource()
        
        formSubmissionSubscription()
        signInCompletedSubscription()
    }
    
    func formSubmissionSubscription() {
        formContentBuilder
            .formSubmission
            .sink { [weak self] completedForm in
                if let self = self {
                    self.viewModel?.signIn(form: completedForm)
                }
            }
            .store(in: &subscriptions)
    }
    
    func signInCompletedSubscription() {
        viewModel?.signInSubject.sink(receiveCompletion: { (error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Uh Oh", message: "There was an issue signing in. \n Error: \(String(describing: error))", preferredStyle: .alert)
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
}

// MARK: - UICollectionViewCell builders
private extension SignInScreen {
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
    
}
