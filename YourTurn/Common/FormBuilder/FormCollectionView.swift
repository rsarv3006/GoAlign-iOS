//
//  FormCollectionView.swift
//  YourTurn
//
//  Created by rjs on 7/19/22.
//

import Foundation
import UIKit

final class FormCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerCells()
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerCells() {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellId)
        register(FormButtonCollectionViewCell.self, forCellWithReuseIdentifier: FormButtonCollectionViewCell.cellId)
        register(FormTextCollectionViewCell.self, forCellWithReuseIdentifier: FormTextCollectionViewCell.cellId)
        register(FormDateCollectionViewCell.self, forCellWithReuseIdentifier: FormDateCollectionViewCell.cellId)
        register(
            FormSwitchControlledTextCVC.self,
            forCellWithReuseIdentifier: FormSwitchControlledTextCVC.cellId)
        register(
            FormSwitchControlledDateCVC.self,
            forCellWithReuseIdentifier: FormSwitchControlledDateCVC.cellId)
        register(FormHideableIntervalPickerCVC.self, forCellWithReuseIdentifier: FormHideableIntervalPickerCVC.cellId)
        register(FormPasswordCollectionViewCell.self, forCellWithReuseIdentifier: FormPasswordCollectionViewCell.cellId)
        register(FormModalCollectionViewCell.self, forCellWithReuseIdentifier: FormModalCollectionViewCell.cellId)
        register(FormTextBoxCollectionViewCell.self, forCellWithReuseIdentifier: FormTextBoxCollectionViewCell.cellId)
        register(FormLabelCollectionViewCell.self, forCellWithReuseIdentifier: FormLabelCollectionViewCell.cellId)
    }
}
