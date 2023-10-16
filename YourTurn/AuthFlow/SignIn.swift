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
    private lazy var buttonToSignUpScreen: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        return button
    }()

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        configureCollectionView()
        configureInteractables()
    }

    // MARK: - Helpers
    override func configureView() {
        view.backgroundColor = .customBackgroundColor
        let topSafeAnchor = view.safeAreaLayoutGuide.topAnchor
        let leftSafeAnchor = view.safeAreaLayoutGuide.leftAnchor
        let rightSafeAnchor = view.safeAreaLayoutGuide.rightAnchor
        let bottomSafeAnchor = view.safeAreaLayoutGuide.bottomAnchor

        view.addSubview(topLabel)
        topLabel.centerX(inView: view, topAnchor: topSafeAnchor, paddingTop: 32)

        view.addSubview(collectionView)
        collectionView.anchor(
            top: topLabel.bottomAnchor,
            left: leftSafeAnchor,
            bottom: bottomSafeAnchor,
            right: rightSafeAnchor,
            paddingTop: 24)

        view.addSubview(buttonToSignUpScreen)
        buttonToSignUpScreen.centerX(inView: view)
        buttonToSignUpScreen.anchor(bottom: bottomSafeAnchor, paddingBottom: 32)
    }

    @objc func onButtonToSignUpScreenPressed() {
        delegate?.requestOtherAuthScreen(viewController: self)
    }
}

private extension SignInScreen {
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
            .throttle(for: .seconds(2.0), scheduler: RunLoop.current, latest: false)
            .sink { [weak self] completedForm in
                if let self = self {
                    self.viewModel?.signIn(form: completedForm)
                }
            }
            .store(in: &subscriptions)
    }

    func signInCompletedSubscription() {
        viewModel?.signInSubject.sink(receiveValue: { result in
            self.showLoader(false)
            switch result {
            case .failure(let error):
                Logger.log(logLevel: .Verbose, name: Logger.Events.Auth.signInFailed, payload: ["error": error])
                let errorStringToDisplay = AuthenticationService.checkForStandardErrors(error: error)
                AlertModalService.openAlert(viewController: self, modalMessage: errorStringToDisplay)
            case .success(let result):
                if let result {
                    self.delegate?.requestInputCodeScreen(viewController: self, loginRequestModel: result)
                }
            }
        }).store(in: &subscriptions)
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<FormSectionComponent, FormComponent> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else {
                let cell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier:
                            UICollectionViewCell.cellId, for: indexPath)
                return cell
            }

            switch item {
            case is TextFormComponent:
                return self.buildFormTextCollectionViewCell(
                    collectionView: collectionView,
                    indexPath: indexPath,
                    item: item)
            case is ButtonFormComponent:
                return self
                    .buildFormButtonCollectionViewCell(
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
}

// MARK: - UICollectionViewCell builders
private extension SignInScreen {
    func buildDefaultCollectionViewCell(
        collectionView: UICollectionView,
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellId, for: indexPath)
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
}
