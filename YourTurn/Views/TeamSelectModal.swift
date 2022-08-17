//
//  TeamSelectModal.swift
//  YourTurn
//
//  Created by rjs on 8/16/22.
//

import Foundation
import UIKit

class TeamSelectModal: UIViewController {
    
    private lazy var closeButton: StandardButton = {
        let button = StandardButton()
        button.setTitle("CLOSE", for: .normal)
        return button
    }()
    
    private lazy var subView: UIView = {
        let subView = UIView()
        subView.backgroundColor = .gray
        subView.layer.cornerRadius = 10
        return subView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(subView)
        subView.center(inView: view)
        
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        subView.setWidth(screenWidth * 0.75)
        subView.setHeight(screenHeight * 0.6)
        
        subView.addSubview(closeButton)
        closeButton.centerX(inView: subView)
        closeButton.anchor(left: subView.leftAnchor, bottom: subView.bottomAnchor, right: subView.rightAnchor, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
        
        closeButton.addTarget(self, action: #selector(onClosePressed), for: .touchUpInside)
    }
    
    @objc func onClosePressed() {
        self.dismiss(animated: true)
    }
}

extension TeamSelectModal: UITableViewDelegate {
    
}

extension TeamSelectModal: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - Continue Implementation
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - Continue Implementation
        return UITableViewCell()
    }
    
    
}
