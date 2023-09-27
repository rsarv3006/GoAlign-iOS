//
//  LegalScreen.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 9/26/23.
//

import UIKit

class LegalScreen: UIViewController {

    private let viewModel = LegalScreenVM()
    
    // MARK: - UI Components
    private lazy var eulaTitleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.eulaTitle
        label.font = .systemFont(ofSize: 16)
        label.textColor = .customText
        return label
    }()
    
    private lazy var privacyPolicyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.privacyPolicyTitle
        label.font = .systemFont(ofSize: 16)
        label.textColor = .customText
        return label
    }()
    
    private lazy var eulaTextView: UITextView = {
        let textView = UITextView()
        textView.text = viewModel.eulaText
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .customText
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .customBackgroundColor
        return textView
    }()
    
    private lazy var privacyPolicyTextView: UITextView = {
        let textView = UITextView()
        textView.text = viewModel.privacyPolicyText
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .customText
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .customBackgroundColor
        return textView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        self.title = viewModel.title
        configureView()
    }
    
    private func configureView() {
        let screenHeight = UIScreen.main.bounds.height
        
        view.addSubview(eulaTitleLabel)
        eulaTitleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        
        view.addSubview(eulaTextView)
        eulaTextView.anchor(top: eulaTitleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 8, paddingRight: 8, height: screenHeight * 0.35)
        
        view.addSubview(privacyPolicyTitleLabel)
        privacyPolicyTitleLabel.centerX(inView: view, topAnchor: eulaTextView.bottomAnchor, paddingTop: 16)
        
        view.addSubview(privacyPolicyTextView)
        privacyPolicyTextView.anchor(top: privacyPolicyTitleLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 8, paddingRight: 8)
    }



}
