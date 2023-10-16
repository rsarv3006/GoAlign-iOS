//
//  InputTextView.swift
//  YourTurn
//
//  Created by rjs on 11/4/22.
//

import Foundation
import UIKit

class InputTextView: UITextView {
    // MARK: - Properties
    var placeholderLabel: UILabel = {
        let placeholder = UILabel()
        placeholder.textColor = .lightGray
        placeholder.numberOfLines = 0
        placeholder.lineBreakMode = .byWordWrapping
        return placeholder
    }()

    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }

    var placeholderFont: UIFont? {
        didSet {
            placeholderLabel.font = placeholderFont
        }
    }

    var placeholderFontColor: UIColor = UIColor.lightGray {
        didSet {
            placeholderLabel.textColor = placeholderFontColor
        }
    }

    var horizontalAlignment: NSTextAlignment = .left {
        didSet {
            self.textAlignment = horizontalAlignment
            placeholderLabel.textAlignment = horizontalAlignment
        }
    }

    var isPlaceHolderHidden: Bool = false {
        didSet {
            placeholderLabel.isHidden = isPlaceHolderHidden
        }
    }

    // MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        addSubview(placeholderLabel)

        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 8)
        placeholderLabel.centerX(inView: self)

        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    func configurePlaceholderTextView() -> UILabel {
        let placeholder = UILabel()
        placeholder.textColor = .lightGray
        return placeholder
    }

    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
