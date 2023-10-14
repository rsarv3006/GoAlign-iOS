//
//  FormPickerCollectionViewCell.swift
//  YourTurn
//
//  Created by rjs on 8/15/22.
//

import UIKit
import Combine

class FormModalCollectionViewCell: UICollectionViewCell {
    private var item: ModalFormComponent?
    private var indexPath: IndexPath?
    
    private var subscriptions = Set<AnyCancellable>()
    private(set) var subject = PassthroughSubject<(Any, IndexPath), Never>()
    private(set) var reload = PassthroughSubject<String, Never>()
    private(set) var openModal = PassthroughSubject<UIViewController, Never>()
    
    // MARK: - UIElements
    private lazy var openModalButton: BlueButton = {
        let button = BlueButton()
        return button
    }()
    
    private lazy var errorLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.systemRed
        lbl.text = ""
        return lbl
    }()
    
    private lazy var contentStackVw: UIStackView = {
        let stackVw = UIStackView()
        stackVw.translatesAutoresizingMaskIntoConstraints = false
        stackVw.axis = .vertical
        stackVw.spacing = 6
        return stackVw
    }()
    
    // MARK: - Lifecycle
    func bind(_ item: FormComponent,
              at indexPath: IndexPath) {
        guard let item = item as? ModalFormComponent else { return }
        self.indexPath = indexPath
        self.item = item
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
        self.item = nil
        self.indexPath = nil
        subscriptions = []
    }
}

// MARK: View Configuration
private extension FormModalCollectionViewCell {
    func configureViews() {
        openModalButton.setTitle(item?.buttonTitle, for: .normal)
        
        contentView.addSubview(contentStackVw)
        contentStackVw.addArrangedSubview(openModalButton)
        
        openModalButton.addTarget(self, action: #selector(onOpenModalPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            openModalButton.heightAnchor.constraint(equalToConstant: 44),
            errorLbl.heightAnchor.constraint(equalToConstant: 22),
            contentStackVw.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentStackVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    @objc func onOpenModalPressed() {
        guard let modal = item?.viewControllerToOpen else { return }
        modal.delegate = self
        openModal.send(modal)
    }
}

// MARK: Combine Configuration
extension FormModalCollectionViewCell {
    func configureCombineEvents() {}
    
}

extension FormModalCollectionViewCell: ModalDelegate {
    func modalSentValue(viewController: ModalViewController, value: Any) {
        guard let indexPath = indexPath else { return }
        subject.send((value, indexPath))
    }
}
