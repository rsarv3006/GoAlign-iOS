//
//  DrawerMenuViewController.swift
//  YourTurn
//
//  Created by rjs on 8/14/22.
//

import UIKit

protocol DrawerMenuViewControllerDelegate {
    func onLogOutPressed(viewController: UIViewController)
    func onViewTeamInvitesPressed(viewController: UIViewController)
    func onViewSettingsPressed(viewController: UIViewController)
    func onViewLegalScreenPressed(viewController: UIViewController)
}

class DrawerMenuViewController: UIViewController {
    // MARK: - Properties
    var delegate: DrawerMenuViewControllerDelegate?

    let transitionManager = DrawerTransitionManager()

    let viewInvitesButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.imagePadding = 6

        let button = UIButton(configuration: config)
        button.setTitle("Invites", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)

        button.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
        return button
    }()

    let viewSettingsButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.imagePadding = 6

        let button = UIButton(configuration: config)
        button.setTitle("Settings", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)

        button.setImage(UIImage(systemName: "gear.circle"), for: .normal)
        return button
    }()

    private lazy var legalScreenButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.imagePadding = 6

        let button = UIButton(configuration: config)
        button.setTitle("Legal", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)

        button.setImage(UIImage(systemName: "doc.text"), for: .normal)
        return button
    }()

    let logoutButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.imagePadding = 6

        let button = UIButton(configuration: config)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)

        button.setImage(UIImage(systemName: "arrow.uturn.backward.circle"), for: .normal)
        return button
    }()

    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureInteractables()
    }
}

extension DrawerMenuViewController {
    func configureViews() {
        view.backgroundColor = .customBackgroundColor
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

        view.addSubview(viewInvitesButton)
        viewInvitesButton.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 48)

        view.addSubview(viewSettingsButton)
        viewSettingsButton.centerX(inView: view, topAnchor: viewInvitesButton.bottomAnchor, paddingTop: 16)

        view.addSubview(legalScreenButton)
        legalScreenButton.centerX(inView: view, topAnchor: viewSettingsButton.bottomAnchor, paddingTop: 16)

        view.addSubview(logoutButton)
        logoutButton.centerX(inView: view, topAnchor: legalScreenButton.bottomAnchor, paddingTop: 16)

    }

    func configureInteractables() {
        logoutButton.addTarget(self, action: #selector(onLogoutButtonPressed), for: .touchUpInside)
        viewInvitesButton.addTarget(self, action: #selector(onViewInvitesButtonPressed), for: .touchUpInside)
        viewSettingsButton.addTarget(self, action: #selector(onviewSettingsButtonPressed), for: .touchUpInside)
        legalScreenButton.addTarget(self, action: #selector(onLegalScreenButtonPressed), for: .touchUpInside)
    }

    @objc func onViewInvitesButtonPressed() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.delegate?.onViewTeamInvitesPressed(viewController: self)
        }

    }

    @objc func onviewSettingsButtonPressed() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.delegate?.onViewSettingsPressed(viewController: self)
        }
    }

    @objc func onLegalScreenButtonPressed() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.delegate?.onViewLegalScreenPressed(viewController: self)
        }
    }

    @objc func onLogoutButtonPressed() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.removeFromParent()
            }

            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
                alert.removeFromParent()
                self.delegate?.onLogOutPressed(viewController: self)
                Logger.log(logLevel: .Verbose, name: Logger.Events.User.userRequestedLogout, payload: [:])
            }

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)

            self.present(alert, animated: true)
        }
    }

}
