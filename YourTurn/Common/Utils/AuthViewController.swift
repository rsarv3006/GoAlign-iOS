//
//  AuthViewController.swift
//  YourTurn
//
//  Created by rjs on 8/10/22.
//

import UIKit
import Combine

enum AuthScreenIdVariant {
    case SignIn
    case SignUp
    case ForgotPassword
}

class AuthViewController: YtViewController {
    private(set) var screenId: AuthScreenIdVariant? = nil
    
    var subscriptions = Set<AnyCancellable>()
    weak var delegate: AuthScreenDelegate?
    
    private lazy var formCompLayout = FormCompositionalLayout()
    lazy var collectionView: UICollectionView = {
        return FormCollectionView(frame: .zero, collectionViewLayout: formCompLayout.layout)
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textColor = .customTitleText
        return label
    }()
    
    func setScreenId(screenId : AuthScreenIdVariant) {
        self.screenId = screenId
    }
}
