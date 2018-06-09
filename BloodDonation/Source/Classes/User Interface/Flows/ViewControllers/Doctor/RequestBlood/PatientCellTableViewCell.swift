//
//  PatientCell.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 07/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

class PatientCell: UITableViewCell {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(patient: Patient) {
        patientNameLabel.text = patient.name!
        bloodTypeLabel.text = patient.bloodType!
    }

}
