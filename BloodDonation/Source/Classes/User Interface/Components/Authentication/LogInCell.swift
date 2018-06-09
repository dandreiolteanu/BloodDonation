//
//  LogInCell.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 22/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol LogInCellDelegate: class {
    func didPressLogIn(with email: String, password: String)
}

class LogInCell: UICollectionViewCell {

    weak var delegate: LogInCellDelegate?

    static let reuseIdentifier = "LogInCell"

    private let logInButton = UIButton(type: .system)
    private let emailTextField = RoundedBorderTextField(type: .email)
    private let passwordTextField = RoundedBorderTextField(type: .password)
    private let stackView = UIStackView()
    private var stackViewCenterY: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(Color.white, for: .normal)
        logInButton.backgroundColor = Color.red
        logInButton.layer.cornerRadius = 8
        logInButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        contentView.addSubview(logInButton)

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(logInButton)
        contentView.addSubview(stackView)
    }

    private func setupConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85).isActive = true

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85).isActive = true

        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logInButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackViewCenterY = stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 60)
        stackViewCenterY.isActive = true
    }

    func keyboardWillShow(_ keyboardHeight: CGFloat) {
        let constant = contentView.frame.size.height / 2 - keyboardHeight - stackView.frame.size.height / 2
        stackViewCenterY.constant = constant
        UIView.animate(withDuration: 0.3) {
            self.contentView.layoutIfNeeded()
        }
    }

    func keyboardWillHide() {
        stackViewCenterY.constant = 100
        UIView.animate(withDuration: 0.3) {
            self.contentView.layoutIfNeeded()
        }
    }

    @objc private func didTapLogIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard email.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        guard password.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        delegate?.didPressLogIn(with: email, password: password)
    }
}
