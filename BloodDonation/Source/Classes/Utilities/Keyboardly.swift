//
//  Keyboardly.swift
//  Jinder
//
//  Created by Andrei Olteanu on 21/04/2018.
//  Copyright © 2018 Halcyon Mobile. All rights reserved.
//

import UIKit

protocol KeyboardlyDelegate: class {
    func keyboardWillShow(keyboardHeight: CGFloat)
    func keyboardWillDissappear()
}

class Keyboardly {
    weak var delegate: KeyboardlyDelegate?
    static let shared = Keyboardly()

    private init() {
        NotificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    deinit {
        NotificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            delegate?.keyboardWillShow(keyboardHeight: keyboardHeight)
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        delegate?.keyboardWillDissappear()
    }
}
