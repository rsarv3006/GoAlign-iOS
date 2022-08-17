//
//  DrawerMenuViewController.swift
//  YourTurn
//
//  Created by rjs on 8/14/22.
//

import UIKit

protocol DrawerMenuViewControllerDelegate {
    func onLogOutPressed(viewController: UIViewController)
}

class DrawerMenuViewController: UIViewController {
    // MARK: - Properties
    var delegate: DrawerMenuViewControllerDelegate?
    
    let transitionManager = DrawerTransitionManager()
    
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
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(logoutButton)
        logoutButton.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: 32)

    }
    
    func configureInteractables() {
        logoutButton.addTarget(self, action: #selector(onLogoutButtonPressed), for: .touchUpInside)
    }

    @objc func onLogoutButtonPressed() {
        delegate?.onLogOutPressed(viewController: self)
    }
}
