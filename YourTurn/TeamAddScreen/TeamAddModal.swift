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
    func onTeamAddGoToInvite(viewController: UIViewController, teamId: String)
}

class TeamAddModal: YtViewController {
    private var subscriptions = Set<AnyCancellable>()
    var delegate: TeamAddModalDelegate?
    
    var viewModel: TeamAddModalVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            createButton.setTitle(viewModel.closeButtonTitleText, for: .normal)
            modalTitle.text = viewModel.modalTitleText
            teamNameField.placeholder = viewModel.teamNameFieldPlacholderText
            createAndInviteButton.setTitle(viewModel.createTeamAndInviteButtonText, for: .normal)
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
    
    private lazy var createAndInviteButton: StandardButton = {
        let button = StandardButton()
        return button
    }()
    
    private lazy var subView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .systemGray4
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
        configureActions()
    }
    
    // MARK: - Helpers
    override func configureView() {
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
        
        subView.addSubview(createAndInviteButton)
        createAndInviteButton.anchor(left: subView.leftAnchor, bottom: createButton.topAnchor, right: subView.rightAnchor, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
        
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
        createAndInviteButton.addTarget(self, action: #selector(onCreateAndInvitePressed), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func onCreatePressed() {
        if let teamName = teamNameField.text {
            if teamName.count < 6 {
                errorLbl.text = "Team Name is too short"
            } else if teamName.count >= 24 {
                errorLbl.text = "Team Name is too long"
            } else {
                showLoader(true)
                createButton.isEnabled = false
                createTeam(teamName: teamName)
            }
        }
        
    }
    
    @objc func onCreateAndInvitePressed() {
        if let teamName = teamNameField.text {
            if teamName.count < 6 {
                errorLbl.text = "Team Name is too short"
            } else if teamName.count >= 24 {
                errorLbl.text = "Team Name is too long"
            } else {
                showLoader(true)
                createAndInviteButton.isEnabled = false
                createTeamAndGoToInvite(teamName: teamName)
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
    
    func createTeam(teamName: String) {
        viewModel?.createTeam(name: teamName, completion: { team, error in
            self.showLoader(false)
            DispatchQueue.main.async {
                self.createButton.isEnabled = true
            }
            
            if let error = error {
                self.handleTeamCreateFail(error: error, teamName: teamName)
            } else {
                Logger.log(logLevel: .Verbose, name: Logger.Events.Team.teamCreated, payload: ["teamId": team?.teamId ?? "unknown", "teamName": teamName])
                self.closeModal()
                self.delegate?.onTeamAddScreenComplete(viewController: self)
            }
        })
    }
    
    func createTeamAndGoToInvite(teamName: String) {
        viewModel?.createTeam(name: teamName, completion: { team, error in
            self.showLoader(false)
            DispatchQueue.main.async {
                self.createAndInviteButton.isEnabled = true
            }
            
            if let error = error {
                self.handleTeamCreateFail(error: error, teamName: teamName)
            } else {
                guard let teamId = team?.teamId else {
                    Logger.log(logLevel: .Prod, name: Logger.Events.Team.teamCreateFailed, payload: ["error": "\(String(describing: error))", "teamName": teamName, "message": "Unable to identify teamID after team creation"])
                    return
                }
                
                Logger.log(logLevel: .Verbose, name: Logger.Events.Team.teamCreated, payload: ["teamId": teamId, "teamName": teamName])
                self.closeModal()
                self.delegate?.onTeamAddGoToInvite(viewController: self, teamId: teamId)
            }
        })
    }
    
    private func handleTeamCreateFail(error: Error, teamName: String) {
        Logger.log(logLevel: .Prod, name: Logger.Events.Team.teamCreateFailed, payload: ["error": error, "teamName": teamName])
        self.showMessage(withTitle: "Uh Oh", message: viewModel?.createTeamCreateFailErrorMessageString(error: error) ?? "Encountered an issue saving the team.")
    }
    
    func setUpTextFieldListener() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: teamNameField)
            .compactMap { ($0.object as?UITextField)?.text }
            .sink { [weak self] val in
                self?.errorLbl.text = ""
            }.store(in: &subscriptions)
    }
}

extension TeamAddModal: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        teamNameField.resignFirstResponder()
        return false
    }
}

