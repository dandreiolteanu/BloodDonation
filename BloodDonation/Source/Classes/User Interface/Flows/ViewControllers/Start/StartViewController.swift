//
//  StartViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 24/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

enum UserType: Int {
    case donor
    case nurse
    case doctor
}

protocol StartFlowDelegate: class {
    func didPressButton(with type: UserType, on viewController: StartViewController)
}

class StartViewController: BaseStoryboardViewController {

    // MARK: - Public Properties

    weak var flowDelegate: StartFlowDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func setupNavigationController() {
        super.setupNavigationController()
    }

    @IBAction func nurseButtonPressed(_ sender: Any) {
        flowDelegate?.didPressButton(with: .nurse, on: self)
    }

    @IBAction func doctorButtonPressed(_ sender: Any) {
        flowDelegate?.didPressButton(with: .doctor, on: self)
    }

    @IBAction func donorButtonPressed(_ sender: Any) {
        flowDelegate?.didPressButton(with: .donor, on: self)
    }

}
