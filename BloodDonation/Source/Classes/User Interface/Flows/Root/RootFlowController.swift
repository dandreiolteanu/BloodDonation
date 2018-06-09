//
//  RootFlowController.swift
//  {project}
//
//  Created by Tamas Levente on 5/17/17.
//  Copyright © 2017 HalcyonMobile. All rights reserved.
//

import UIKit

class RootFlowController {
    private weak var window: UIWindow?

    private let userDefaults = UserDefaultsManager.shared

    private var authenticationFlowController: AuthenticationFlowController!
    private var nurseFlowController: NurseFlowController!
    private var donorViewController: DonorViewController!
    private var doctorFlowController: DoctorFlowController!

    // MARK: - Lifecycle

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        if let donorID = userDefaults.getDonorId() {
            showDonorFlow(id: donorID)
        } else if let nurseId = userDefaults.getNurseId() {
            showNurseFlow(id: nurseId)
        } else if let doctorId = userDefaults.getDoctorId() {
            showDoctorFlow(id: doctorId)
        } else {
            showAuthenticationFlow()
        }
    }

    private func showAuthenticationFlow() {
        authenticationFlowController = AuthenticationFlowController()
        authenticationFlowController.flowDelegate = self
        show(flow: authenticationFlowController, animated: true)
    }

    private func logOutAndShowAuthenticationFlow() {
        userDefaults.clear()
        showAuthenticationFlow()
    }

    // MARK: - Set root

    fileprivate var root: UIViewController? {
        return window?.rootViewController
    }

    fileprivate func setRoot(to viewController: UIViewController?, animated: Bool = false) {
        guard let viewController = viewController else { return }

        guard root != viewController else { return }

        func changeRoot(to viewController: UIViewController) {
            window?.rootViewController = viewController
        }

        if animated, let snapshotView = window?.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshotView)

            changeRoot(to: viewController)

            UIView.animate(withDuration: 0.33, animations: {
                snapshotView.alpha = 0.0
            }, completion: { _ in
                snapshotView.removeFromSuperview()
            })
        } else {
            changeRoot(to: viewController)
        }
    }

    // MARK: - Show flows

    fileprivate func show(flow: FlowController, animated: Bool = true) {
        flow.start { flowMainController in
            self.setRoot(to: flowMainController, animated: animated)
        }
    }
}

extension RootFlowController: AuthenticationViewControllerFlowDelegate {
    func didTapRegistration(id: Int) {
        userDefaults.setDonorId(newValue: id)
        showDonorFlow(id: id)
    }

    func didTapLogin(for type: UserType, id: Int) {
        AuthenticationService.shared.getIdWithAccount(type: type, userId: id) { userId in
            switch type {
            case .donor:
                self.userDefaults.setDonorId(newValue: userId)
                self.showDonorFlow(id: userId)
            case .nurse:
                self.userDefaults.setNurseId(newValue: userId)
                self.showNurseFlow(id: userId)
            case .doctor:
                self.userDefaults.setDoctorId(newValue: userId)
                self.showDoctorFlow(id: userId)
            }
        }

    }

    func didTapContinueOnBaseRegistration(type: UserType, id: Int) {
        switch type {
        case .nurse:
            userDefaults.setNurseId(newValue: id)
            showNurseFlow(id: id)
        case .doctor:
            userDefaults.setDoctorId(newValue: id)
            showDoctorFlow(id: id)
        default:
            break
        }
    }

    private func showDonorFlow(id: Int) {
        donorViewController = DonorViewController.instantiate()
        donorViewController.flowDelegate = self
        donorViewController.userId = id
        setRoot(to: donorViewController, animated: true)
    }

    private func showNurseFlow(id: Int) {
        nurseFlowController = NurseFlowController()
        nurseFlowController.flowDelegate = self
        nurseFlowController.userId = id
        show(flow: nurseFlowController, animated: true)
    }

    private func showDoctorFlow(id: Int) {
        doctorFlowController = DoctorFlowController()
        doctorFlowController.flowDelegate = self
        doctorFlowController.userId = id
        show(flow: doctorFlowController, animated: true)
    }
}

extension RootFlowController: DonorFlowDelegate {
    func didTapLogOutDonor() {
        logOutAndShowAuthenticationFlow()
    }
}

extension RootFlowController: NurseFlowControllerDelegate {
    func didTapLogOutNurse() {
        logOutAndShowAuthenticationFlow()
    }
}

extension RootFlowController: DoctorFlowControllerDelegate {
    func didTapLogOutDoctor() {
        logOutAndShowAuthenticationFlow()
    }
}
