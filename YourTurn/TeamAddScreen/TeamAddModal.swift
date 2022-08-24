//
//  TeamAddModal.swift
//  YourTurn
//
//  Created by rjs on 8/22/22.
//

import UIKit
import Combine

protocol TeamAddModalDelegate {
    func onTeamAddScreenComplete(viewController: UIViewController)
}

class TeamAddModal: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    var delegate: TeamAddModalDelegate?
    
    var viewModel: TeamAddModalVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            createButton.setTitle(viewModel.closeButtonTitleText, for: .normal)
            modalTitle.text = viewModel.modalTitleText
            teamNameField.placeholder = viewModel.teamNameFieldPlacholderText
        }
    }
    
    // MARK: - UI Elements
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
    
    private lazy var createButton: StandardButton = {
        let button = StandardButton()
        return button
    }()
    
    private lazy var subView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .gray
        subView.layer.cornerRadius = 10
        return subView
    }()
    
    private lazy var modalTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var errorLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.systemRed
        lbl.text = ""
        return lbl
    }()
    
    private lazy var teamNameField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .roundedRect
        txtField.backgroundColor = .clear
        txtField.delegate = self
        txtField.layer.borderColor = UIColor.systemGray5.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        return txtField
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModal()
        configureView()
        configureActions()
    }
    
    // MARK: - Helpers
    func configureView() {
        subView.addSubview(modalTitle)
        modalTitle.centerX(inView: subView)
        modalTitle.anchor(top: subView.topAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 44)
        
        subView.addSubview(teamNameField)
        teamNameField.centerY(inView: subView)
        teamNameField.anchor(left: subView.leftAnchor, right: subView.rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        subView.addSubview(createButton)
        createButton.centerX(inView: subView)
        createButton.anchor(left: subView.leftAnchor, bottom: subView.bottomAnchor, right: subView.rightAnchor, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
        
        subView.addSubview(errorLbl)
        errorLbl.centerX(inView: subView)
        errorLbl.anchor(top: teamNameField.bottomAnchor, left: subView.leftAnchor, right: subView.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        subView.addSubview(closeButton)
        closeButton.anchor(top: subView.topAnchor, left: subView.leftAnchor, paddingTop: 6, paddingLeft: 6)
    }
    
    func configureModal() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(subView)
        subView.center(inView: view)
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        subView.setWidth(screenWidth * 0.75)
        subView.setHeight(screenHeight * 0.6)
    }
    
    func configureActions() {
        createButton.addTarget(self, action: #selector(onCreatePressed), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(onClosePressed), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func onCreatePressed() {
        if let teamName = teamNameField.text {
            if teamName.count < 6 {
                errorLbl.text = "Team Name is too short"
            } else if teamName.count >= 16 {
                errorLbl.text = "Team Name is too long"
            } else {
                createTeamCallToViewModel(teamName: teamName)
            }
        }

    }
    
    @objc func onClosePressed() {
        closeModal()
    }
    
    func closeModal() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func createTeamCallToViewModel(teamName: String) {
        viewModel?.createTeam(name: teamName, completion: { team, error in
            if let error = error {
                print(error)
                Logger.log(logLevel: .Prod, message: String(describing: error))
            }
            
            self.closeModal()
            self.delegate?.onTeamAddScreenComplete(viewController: self)
        })
    }
    
    func setUpTextFieldListener() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: teamNameField)
            .compactMap { ($0.object as?UITextField)?.text }
            .map(String.init)
            .sink { [weak self] val in
                self?.errorLbl.text = ""
            }.store(in: &subscriptions)
    }
}

extension TeamAddModal: UITextFieldDelegate {
    
}

