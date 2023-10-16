//
//  FormLabelCollectionViewCell.swift
//  GoAlign
//
//  Created by Robert J. Sarvis Jr on 9/26/23.
//

import UIKit
import Combine

class FormLabelCollectionViewCell: UICollectionViewCell {

    private var item: LabelFormComponent?
    private var indexPath: IndexPath?

    func bind(_ item: FormComponent,
              at indexPath: IndexPath) {
        guard let item = item as? LabelFormComponent else { return }
        self.indexPath = indexPath
        self.item = item
        setup(item: item)
        self.backgroundColor = .clear
        label.text = item.labelText
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
        self.item = nil
        self.indexPath = nil
    }

    private lazy var labelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .customTitleText
        label.text = item?.labelText
        return label
    }()

}

private extension FormLabelCollectionViewCell {

    func setup(item: LabelFormComponent) {
        contentView.addSubview(labelContainer)
        labelContainer.anchor(top: contentView.topAnchor,
                              left: contentView.leftAnchor,
                              bottom: contentView.bottomAnchor,
        right: contentView.rightAnchor)

        labelContainer.addSubview(label)
        label.center(inView: labelContainer)
    }

}
