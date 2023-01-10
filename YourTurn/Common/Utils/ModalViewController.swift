//
//  ModalViewController.swift
//  YourTurn
//
//  Created by rjs on 8/19/22.
//

import UIKit

class ModalViewController: UIViewController {
    var delegate: ModalDelegate?
    
    var editValue: Dictionary<String, String?>?
    
    lazy var subView: UIView = {
       let subView = UIView()
       subView.backgroundColor = .systemGray4
       subView.layer.cornerRadius = 10
       return subView
   }()
}
