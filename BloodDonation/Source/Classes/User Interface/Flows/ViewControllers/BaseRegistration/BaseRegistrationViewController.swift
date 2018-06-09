//
//  BaseRegistrationViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol BaseRegistrationFlowDelegate: class {
    func didTapContinue(type: UserType, id: Int)
}

class BaseRegistrationViewController: UIViewController {

    var userId: Int!
    var userType: UserType!
    weak var flowDelegate: BaseRegistrationFlowDelegate?

    @IBOutlet weak var nameTextField: RoundedBorderTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        nameTextField.becomeFirstResponder()
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        guard nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        AuthenticationService.shared.getMaxIdFor(type: userType) { maxId in
            if self.userType == .nurse {
                let nurse = Nurse(NID: NSNumber(value: maxId), name: self.nameTextField.text, AID: NSNumber(value: self.userId))
                AuthenticationService.shared.createNurse(nurse: nurse.dictionary())
            } else {
                let doctor = Doctor(DID: NSNumber(value: maxId), name: self.nameTextField.text, AID: NSNumber(value: self.userId))
                AuthenticationService.shared.createDoctor(doctor: doctor.dictionary())
            }
            self.flowDelegate?.didTapContinue(type: self.userType, id: maxId)
        }
    }
}
