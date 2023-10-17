//
//  SignUp.swift
//  YourTurn
//
//  Created by rjs on 7/22/22.
//

import Foundation
import UIKit
import Combine

class SignUpScreen: AuthViewController {

    var viewModel: SignUpVM? {
        didSet {
            topLabel.text = viewModel?.welcomeLabelText
            buttonToSignInScreen.setTitle(viewModel?.buttonTextGoToSignIn, for: .normal)
        }
    }

    private lazy var formContentBuilder = SignUpFormContentBuilderImpl()
    private lazy var dataSource = makeDataSource()

    // MARK: UI Elements
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
        configureInteractables()
    }

    // MARK: - Helpers
    @objc func onButtonToSignInScreenPressed() {
        delegate?.requestOtherAuthScreen(viewController: self)
    }

}

private extension SignUpScreen {
    func setup() {
        view.backgroundColor = .customBackgroundColor
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        let leftSafeAnchor = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeAnchor = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeAnchor = view.safeAreaLayoutGuide.bottomAnchor

        formSubmissionSubscription()
        signUpCompletedSubscription()

        collectionView.dataSource = dataSource

        view.addSubview(topLabel)
        topLabel.centerX(inView: view, topAnchor: topSafeAnchor, paddingTop: 32)

        view.addSubview(collectionView)
        collectionView.anchor(
            top: topLabel.bottomAnchor,
            left: leftSafeAnchor,
            bottom: bottomSafeAnchor,
            right: rightSafeAnchor,
            paddingTop: 24)

        view.addSubview(buttonToSignInScreen)
        buttonToSignInScreen.centerX(inView: view)
        buttonToSignInScreen.anchor(bottom: bottomSafeAnchor, paddingBottom: 32)
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<FormSectionComponent, FormComponent> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UICollectionViewCell.cellId,
                    for: indexPath)
                return cell
            }

            switch item {
            case is TextFormComponent:
                return self.buildFormTextCollectionViewCell(
                    collectionView: collectionView,
                    indexPath: indexPath,
                    item: item)
            case is ButtonFormComponent:
                return self.buildFormButtonCollectionViewCell(
                    collectionView: collectionView,
                    indexPath: indexPath,
                    item: item)
            case is PasswordFormComponent:
                return self.buildFormPasswordCollectionViewCell(
                    collectionView: collectionView,
                    indexPath: indexPath,
                    item: item)
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
            .sink { [weak self] completedForm in
                if let self = self {
                    self.viewModel?.signUp(form: completedForm)
                }
            }
            .store(in: &subscriptions)
    }

    func signUpCompletedSubscription() {
        viewModel?.signUpSubject.sink(receiveValue: { result in
            self.showLoader(false)
            switch result {
            case .failure(let error):
                Logger.log(logLevel: .verbose, name: Logger.Events.Auth.signInFailed, payload: ["error": error])
                let errorStringToDisplay = AuthenticationService.checkForStandardErrors(error: error)
                AlertModalService.openAlert(viewController: self, modalMessage: errorStringToDisplay)
            case .success(let createAccountReturnModel):
                if let createAccountReturnModel {
                    self.delegate?.requestInputCodeScreen(
                        viewController: self,
                        loginRequestModel: createAccountReturnModel)
                }
            }
        }).store(in: &subscriptions)
    }

    func configureInteractables() {
        buttonToSignInScreen.addTarget(self, action: #selector(onButtonToSignInScreenPressed), for: .touchUpInside)
    }
}

// MARK: - UICollectionViewCell builders
private extension SignUpScreen {
    func buildDefaultCollectionViewCell(
        collectionView: UICollectionView,
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UICollectionViewCell.cellId,
            for: indexPath)
        return cell
    }

    func buildFormTextCollectionViewCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: FormComponent) -> FormTextCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FormTextCollectionViewCell.cellId,
            // swiftlint:disable:next force_cast
            for: indexPath) as! FormTextCollectionViewCell

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

    func buildFormButtonCollectionViewCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: FormComponent) -> FormButtonCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FormButtonCollectionViewCell.cellId,
            // swiftlint:disable:next force_cast
            for: indexPath) as! FormButtonCollectionViewCell

        cell
            .subject
            .sink { [weak self] id in
                if id == .termsButton {
                    ExternalLinkService.openTermsAndConditionsLink()
                } else {
                    self?.showLoader(true)
                    self?.formContentBuilder.validate()
                }
            }.store(in: &self.subscriptions)

        cell.bind(item)
        return cell
    }

    func buildFormPasswordCollectionViewCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: FormComponent) -> FormPasswordCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FormPasswordCollectionViewCell.cellId,
            // swiftlint:disable:next force_cast
            for: indexPath) as! FormPasswordCollectionViewCell

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
}
