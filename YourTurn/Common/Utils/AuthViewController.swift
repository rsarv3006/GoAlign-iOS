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
        label.font = UIFont(name: "American Typewriter", size: 32)
        return label
    }()
    
    func setScreenId(screenId : AuthScreenIdVariant) {
        self.screenId = screenId
    }
}
