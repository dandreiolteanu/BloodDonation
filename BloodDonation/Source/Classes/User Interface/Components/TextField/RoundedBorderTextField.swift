//
//  RoundedBorderTextField.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 25/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

enum TextFieldEntryType {
    case email
    case password
}

@IBDesignable
class RoundedBorderTextField: UITextField {

    private var type: TextFieldEntryType?
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

    init(type: TextFieldEntryType? = nil) {
        self.type = type
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        borderStyle = .none
        tintColor = Color.black
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.9416350722, green: 0.9360373616, blue: 0.9459379315, alpha: 1)
        layer.cornerRadius = 7
        backgroundColor = #colorLiteral(red: 0.9416350722, green: 0.9360373616, blue: 0.9459379315, alpha: 1)
        textColor = Color.black
        font = UIFont.systemFont(ofSize: 15, weight: .medium)
        autocapitalizationType = .words

        if let type = type {
            switch type {
            case .email:
                placeholder = "Email"
                keyboardType = .emailAddress
                autocapitalizationType = .none
            case .password:
                placeholder = "Password"
                isSecureTextEntry = true
                autocapitalizationType = .none
            }
        }
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
