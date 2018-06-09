//
//  NurseStartViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol NurseFlowDelegate: class {
    func didTapLogOut()
    func didTapSeeAllDonors()
    func didTapSeeAllBloodRequests()
}

class NurseStartViewController: UIViewController, UITextFieldDelegate {

    var userId: Int!
    var nurse: Nurse!
    var patientName: String!
    var bloodType: String!

    weak var flowDelegate: NurseFlowDelegate?

    @IBOutlet weak var nurseNameLabel: UILabel!
    @IBOutlet weak var patientNameTextField: RoundedBorderTextField!
    @IBOutlet weak var selectBloodTypeButton: UIButton!
    @IBOutlet weak var addPatientButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nurse"
        navigationController?.navigationBar.prefersLargeTitles = true

        patientNameTextField.delegate = self
        patientNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        NurseService.shared.getNurse(for: userId) { response in
            switch response {
            case .success:
                self.nurse = NurseService.shared.nurse
                self.nurseNameLabel.text = "\(self.nurse.name!)"
            case .failure:
                print("failure")
            }
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        flowDelegate?.didTapLogOut()
    }

    @IBAction func seeAllDonorsButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.flowDelegate?.didTapSeeAllDonors()
        }
    }

    @IBAction func seeBloodRequestsButtonTapped(_ sender: Any) {
        flowDelegate?.didTapSeeAllBloodRequests()
    }

    @IBAction func addPacientButtonTapped(_ sender: Any) {
        self.patientName = patientNameTextField.text!
        self.bloodType = selectBloodTypeButton.titleLabel?.text!
        NurseService.shared.getPatientMaxId(completion: { maxId in
            let patient = Patient(PID: NSNumber(value: maxId), name: self.patientName, bloodType: self.bloodType)
            NurseService.shared.addPatient(patient: patient.dictionary())
        })
        addPatientButton.alpha = 0.5
        addPatientButton.isEnabled = false
        patientNameTextField.text = ""
        selectBloodTypeButton.setTitle("Select Blood Type", for: .normal)

    }
    
    @IBAction func selectBloodTypePressed(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Blood Type", message: nil)

        let pickerViewValues: [[String]] = [["0", "1", "A2", "B3", "AB4"]]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { _, _, index, _ in
            self.selectBloodTypeButton.setTitle(pickerViewValues[index.column][index.row], for: .normal)
            if self.patientNameTextField.text != "" {
                self.addPatientButton.alpha = 1.0
                self.addPatientButton.isEnabled = true
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != "" && selectBloodTypeButton.titleLabel?.text != "Select Blood Type" {
            addPatientButton.alpha = 1.0
            addPatientButton.isEnabled = true
        } else {
            addPatientButton.alpha = 0.5
            addPatientButton.isEnabled = false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
