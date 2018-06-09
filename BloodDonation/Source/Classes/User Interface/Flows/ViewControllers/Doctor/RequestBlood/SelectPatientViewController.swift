//
//  SelectPatientViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 07/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol SelectPatientFlowDelegate: class {
    func didSelectPatient(patient: Patient, doctor: Doctor)
}

class SelectPatientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var patients = [Patient]()
    var doctor: Doctor!
    weak var flowDelegate: SelectPatientFlowDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Patients"
        navigationItem.largeTitleDisplayMode = .never

        tableView.rowHeight = 75
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self

        DispatchQueue.main.async {
            DoctorService.shared.getPatients { patients in
                self.patients = patients
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath) as? PatientCell else {
            return UITableViewCell()
        }

        cell.tintColor = Color.red
        cell.accessoryType = .disclosureIndicator
        cell.configureCell(patient: patients[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        flowDelegate?.didSelectPatient(patient: patients[indexPath.row], doctor: self.doctor)
    }
}
