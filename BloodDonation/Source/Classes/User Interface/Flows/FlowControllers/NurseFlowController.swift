//
//  NurseFlowController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol NurseFlowControllerDelegate: class {
    func didTapLogOutNurse()
}

class NurseFlowController: NavigationFlowController {

    var userId: Int!
    weak var flowDelegate: NurseFlowControllerDelegate?

    private var nurseStartViewController: NurseStartViewController!
    private var allDonorsViewController: AllDonorsViewController!
    private var acceptRequestsViewController: AcceptRequestsViewController!

    override func firstScreen() -> UIViewController {
        nurseStartViewController = NurseStartViewController.instantiate()
        nurseStartViewController.flowDelegate = self
        nurseStartViewController.userId = userId
        return nurseStartViewController
    }
}

extension NurseFlowController: NurseFlowDelegate {
    func didTapLogOut() {
        flowDelegate?.didTapLogOutNurse()
    }

    func didTapSeeAllDonors() {
        allDonorsViewController = AllDonorsViewController.instantiate()
        navigationController?.pushViewController(allDonorsViewController, animated: true)
    }

    func didTapSeeAllBloodRequests() {
        acceptRequestsViewController = AcceptRequestsViewController.instantiate()
        navigationController?.pushViewController(acceptRequestsViewController, animated: true)
    }
}
