//
//  AuthenticationViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 21/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit
import OHMySQL

enum AuthenticationType: Int {
    case login = 0
    case signup = 1
}

class AuthenticationViewController: BaseStoryboardViewController {

    // MARK: - Outlets

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var authenticationCollectionView: UICollectionView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    // MARK: - Private Properties

    // MARK: - Public Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    var viewModel: AuthenticationViewModel!

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func setupView() {
        super.setupView()
        Keyboardly.shared.delegate = self

        authenticationCollectionView.delegate = self
        authenticationCollectionView.dataSource = self
        authenticationCollectionView.isPagingEnabled = true
        authenticationCollectionView.showsHorizontalScrollIndicator = false
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        authenticationCollectionView.collectionViewLayout = flowLayout
        authenticationCollectionView.register(LogInCell.self, forCellWithReuseIdentifier: LogInCell.reuseIdentifier)
        authenticationCollectionView.register(SignUpCell.self, forCellWithReuseIdentifier: SignUpCell.reuseIdentifier)

        typeLabel.text = "\(Strings.AuthenticationScreen.authTypeBase) \(Strings.AuthenticationScreen.login)"
        configureTitleLabel(for: viewModel.type)
    }

    override func setupNavigationController() {
        super.setupNavigationController()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.tintColor = Color.black
    }

    @IBAction func didTapShowLogInButton(_ sender: Any) {
        authenticationCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
    }

    @IBAction func didTapSignUpButton(_ sender: Any) {
        authenticationCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
    }

    private func configureTitleLabel(for type: UserType) {
        let titleBase = Strings.AuthenticationScreen.titleBase
        switch type {
        case .doctor:
            titleLabel.text = "\(titleBase) \(Strings.AuthenticationScreen.doctor)"
        case .donor:
            titleLabel.text = "\(titleBase) \(Strings.AuthenticationScreen.donor)"
        case .nurse:
            titleLabel.text = "\(titleBase) \(Strings.AuthenticationScreen.nurse)"
        }
    }
}

extension AuthenticationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = AuthenticationType(rawValue: indexPath.item)!
        switch type {
        case .login:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogInCell.reuseIdentifier, for: indexPath) as? LogInCell else {
                assertionFailure("Could not deque LogInCell")
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        case .signup:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SignUpCell.reuseIdentifier, for: indexPath) as? SignUpCell else {
                assertionFailure("Could not deque LogInCell")
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        }
    }
}

extension AuthenticationViewController: KeyboardlyDelegate {
    func keyboardWillShow(keyboardHeight: CGFloat) {
        if let cell = authenticationCollectionView.visibleCells.first as? LogInCell { cell.keyboardWillShow(keyboardHeight) }
        if let cell = authenticationCollectionView.visibleCells.first as? SignUpCell { cell.keyboardWillShow(keyboardHeight) }
        UIView.animate(withDuration: 0.2) {
            self.quoteLabel.alpha = 0
            self.authorLabel.alpha = 0
        }
    }

    func keyboardWillDissappear() {
        if let cell = authenticationCollectionView.visibleCells.first as? LogInCell { cell.keyboardWillHide() }
        if let cell = authenticationCollectionView.visibleCells.first as? SignUpCell { cell.keyboardWillHide() }
        UIView.animate(withDuration: 0.2) {
            self.quoteLabel.alpha = 1
            self.authorLabel.alpha = 1
        }
    }
}

extension AuthenticationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let type = AuthenticationType(rawValue: indexPath.item)!
        switch type {
        case .login:
            self.signUpButton.setTitleColor(Color.black, for: .normal)
            self.logInButton.setTitleColor(UIColor.lightGray, for: .normal)
            self.typeLabel.text = "\(Strings.AuthenticationScreen.authTypeBase) \(Strings.AuthenticationScreen.signup)"
        case .signup:
            self.signUpButton.setTitleColor(UIColor.lightGray, for: .normal)
            self.logInButton.setTitleColor(Color.black, for: .normal)
            self.typeLabel.text = "\(Strings.AuthenticationScreen.authTypeBase) \(Strings.AuthenticationScreen.login)"
        }
    }
}

extension AuthenticationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = authenticationCollectionView.frame.size.height
        let width = view.frame.size.width
        return CGSize(width: width, height: height)
    }
}

extension AuthenticationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension AuthenticationViewController: LogInCellDelegate {
    func didPressLogIn(with email: String, password: String) {
        AuthenticationService.shared.logInWith(for: viewModel.type, email: email, password: password, success: { id in
            self.viewModel.didTapLogin(id: id)
        }, failure: {
            self.showAlert(message: "Email or Password invalid.", title: "Log In Failed!")
        })
    }
}

extension AuthenticationViewController: SignUpCellDelegate {
    func didPressSignUp(with email: String, password: String) {
        AuthenticationService.shared.getMaxId { maxId in
            let id = NSNumber(value: maxId)
            let type = NSNumber(value: self.viewModel.type.rawValue)
            let account = Account(AID: id, email: email, password: password, type: type)
            AuthenticationService.shared.createAccount(account: account.dictionary(), success: {
                self.viewModel.didTapSignUp(id: maxId)
            }, failure: {
                self.showAlert(message: "Email Already In Use")
            })
        }
    }
}
