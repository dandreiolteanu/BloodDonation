//
//  DoctorFlowController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol DoctorFlowControllerDelegate: class {
    func didTapLogOutDoctor()
}

class DoctorFlowController: NavigationFlowController {

    var userId: Int!
    weak var flowDelegate: DoctorFlowControllerDelegate?

    private var doctorStartViewController: DoctorStartViewController!
    private var selectPatientViewController: SelectPatientViewController!
    private var selectBloodBagViewController: SelectBloodBagViewController!
    private var doctorRequestsViewController: DoctorRequestsViewController!

    override func firstScreen() -> UIViewController {
        doctorStartViewController = DoctorStartViewController.instantiate()
        doctorStartViewController.flowDelegate = self
        doctorStartViewController.userId = userId
        return doctorStartViewController
    }
}

extension DoctorFlowController: DoctorFlowDelegate {
    func didTapLogOut() {
        flowDelegate?.didTapLogOutDoctor()
    }

    func didTapCreateBloodRequest(doctor: Doctor) {
        selectPatientViewController = SelectPatientViewController.instantiate()
        selectPatientViewController.flowDelegate = self
        selectPatientViewController.doctor = doctor
        navigationController?.pushViewController(selectPatientViewController, animated: true)
    }

    func didTapSeeAllBloodRequests() {
        doctorRequestsViewController = DoctorRequestsViewController.instantiate()
        navigationController?.pushViewController(doctorRequestsViewController, animated: true)
    }
}

extension DoctorFlowController: SelectPatientFlowDelegate {
    func didSelectPatient(patient: Patient, doctor: Doctor) {
        selectBloodBagViewController = SelectBloodBagViewController.instantiate()
        selectBloodBagViewController.flowDelegate = self
        selectBloodBagViewController.patient = patient
        selectBloodBagViewController.doctor = doctor
        navigationController?.pushViewController(selectBloodBagViewController, animated: true)
    }
}

extension DoctorFlowController: SelectBloodBagFlowDelegate {
    func didRequestBloodButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
}
