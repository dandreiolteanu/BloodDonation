//
//  DoctorStartViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol DoctorFlowDelegate: class {
    func didTapLogOut()
    func didTapCreateBloodRequest(doctor: Doctor)
    func didTapSeeAllBloodRequests()
}

class DoctorStartViewController: UIViewController {

    var userId: Int!
    var doctor: Doctor!
    weak var flowDelegate: DoctorFlowDelegate?

    @IBOutlet weak var doctorNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Doctor"
        navigationController?.navigationBar.prefersLargeTitles = true

        DoctorService.shared.getDoctor(for: userId) { response in
            switch response {
            case .success:
                self.doctor = DoctorService.shared.doctor
                self.doctorNameLabel.text = "\(self.doctor.name!)"
            case .failure:
                print("failure")
            }
        }
    }
    @IBAction func logOutButtonTapped(_ sender: Any) {
        flowDelegate?.didTapLogOut()
    }

    @IBAction func createBloodRequestButtonTapped(_ sender: Any) {
        flowDelegate?.didTapCreateBloodRequest(doctor: self.doctor)
    }

    @IBAction func seeAllBloodRequestButtonTapped(_ sender: Any) {
        flowDelegate?.didTapSeeAllBloodRequests()
    }
}
