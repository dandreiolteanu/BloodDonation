//
//  AuthenticationFlowController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 21/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol AuthenticationViewControllerFlowDelegate: class {
    func didTapRegistration(id: Int)
    func didTapContinueOnBaseRegistration(type: UserType, id: Int)
    func didTapLogin(for type: UserType, id: Int)
}

class AuthenticationFlowController: NavigationFlowController {

    // MARK: - Private Properties

    private var startViewController: StartViewController?
    private var authenticationViewController: AuthenticationViewController?
    private var donorRegistrationViewController: DonorRegistrationViewController!
    private var baseRegistrationViewController: BaseRegistrationViewController!

    weak var flowDelegate: AuthenticationViewControllerFlowDelegate?

    override func firstScreen() -> UIViewController {
        startViewController = StartViewController.instantiate()
        startViewController?.flowDelegate = self
        return startViewController!
    }
}

extension AuthenticationFlowController: StartFlowDelegate {
    func didPressButton(with type: UserType, on viewController: StartViewController) {
        let authenticationViewModel = AuthenticationViewModelImpl(type: type)
        authenticationViewModel.flowDelegate = self
        authenticationViewController = AuthenticationViewController.instantiate()
        authenticationViewController?.viewModel = authenticationViewModel
        self.navigationController?.pushViewController(authenticationViewController!, animated: true)
    }
}

extension AuthenticationFlowController: AuthenticationFlowDelegate {
    func didTapLogin(for type: UserType, id: Int) {
        flowDelegate?.didTapLogin(for: type, id: id)
    }

    func didTapSignUp(for type: UserType, id: Int) {
        switch type {
        case .donor:
            donorRegistrationViewController = DonorRegistrationViewController.instantiate()
            donorRegistrationViewController.userId = id
            donorRegistrationViewController.flowDelegate = self
            navigationController?.pushViewController(donorRegistrationViewController, animated: true)
        case .doctor:
            pushBaseRegistrationViewController(id: id, type: type)
        case .nurse:
            pushBaseRegistrationViewController(id: id, type: type)
        }
    }

    private func pushBaseRegistrationViewController(id: Int, type: UserType) {
        baseRegistrationViewController = BaseRegistrationViewController.instantiate()
        baseRegistrationViewController.userId = id
        baseRegistrationViewController.userType = type
        baseRegistrationViewController.flowDelegate = self
        navigationController?.pushViewController(baseRegistrationViewController, animated: true)
    }
}

extension AuthenticationFlowController: DonorRegistrationFlowDelegate {
    func didTapRegistration(id: Int) {
        flowDelegate?.didTapRegistration(id: id)
    }
}

extension AuthenticationFlowController: BaseRegistrationFlowDelegate {
    func didTapContinue(type: UserType, id: Int) {
        flowDelegate?.didTapContinueOnBaseRegistration(type: type, id: id)
    }
}
