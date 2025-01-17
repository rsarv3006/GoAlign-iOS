//
//  TeamAddModal.swift
//  YourTurn
//
//  Created by rjs on 8/22/22.
//

import UIKit
import Combine

protocol TeamAddModalDelegate: AnyObject {
    func onTeamAddScreenComplete(viewController: UIViewController)
    func onTeamAddGoToInvite(viewController: UIViewController, teamId: UUID)
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

    lazy var createButton: BlueButton = {
        let button = BlueButton()
        return button
    }()

    lazy var createAndInviteButton: BlueButton = {
        let button = BlueButton()
        return button
    }()

    private lazy var subView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .customBackgroundColor
        subView.layer.cornerRadius = 10
        return subView
    }()

    private lazy var modalTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .customTitleText
        label.font = .systemFont(ofSize: 20)
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
        txtField.layer.borderColor = UIColor.customAccentColor?.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        return txtField
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureModal()
        configureActions()
        super.viewDidLoad()
    }

    // MARK: - Helpers
    override func configureView() {
        subView.addSubview(modalTitle)
        modalTitle.centerX(inView: subView)
        modalTitle.anchor(top: subView.topAnchor, left: subView.leftAnchor, right: subView.rightAnchor, height: 44)

        subView.addSubview(teamNameField)
        teamNameField.center(inView: subView)
        teamNameField.setWidth(240)

        subView.addSubview(createButton)
        createButton.centerX(inView: subView)
        createButton.anchor(
            left: subView.leftAnchor,
            bottom: subView.bottomAnchor,
            right: subView.rightAnchor,
            paddingLeft: 12,
            paddingBottom: 12,
            paddingRight: 12)

        subView.addSubview(errorLbl)
        errorLbl.centerX(inView: subView)
        errorLbl.anchor(
            top: teamNameField.bottomAnchor,
            left: subView.leftAnchor,
            right: subView.rightAnchor,
            paddingTop: 12,
            paddingLeft: 12,
            paddingRight: 12)

        subView.addSubview(createAndInviteButton)
        createAndInviteButton.anchor(
            left: subView.leftAnchor,
            bottom: createButton.topAnchor,
            right: subView.rightAnchor,
            paddingLeft: 12,
            paddingBottom: 12,
            paddingRight: 12)

        subView.addSubview(closeButton)
        closeButton.anchor(top: subView.topAnchor, left: subView.leftAnchor, paddingTop: 6, paddingLeft: 6)
    }

    func configureModal() {
        view.addSubview(subView)
        subView.center(inView: view)

        subView.setWidth(310)
        subView.setHeight(442)
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
                viewModel?.createTeam(viewController: self, teamName: teamName)
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
                viewModel?.createTeamAndGoToInvite(viewController: self, teamName: teamName)
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

    func setUpTextFieldListener() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: teamNameField)
            .compactMap { ($0.object as?UITextField)?.text }
            .sink { [weak self] _ in
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
