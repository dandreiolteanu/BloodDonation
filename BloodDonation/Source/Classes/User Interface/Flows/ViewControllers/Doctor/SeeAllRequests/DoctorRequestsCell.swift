//
//  DoctorRequestsCell.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 07/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

class DoctorRequestsCell: UITableViewCell {

    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var bloodBagTypeLabel: UILabel!
    @IBOutlet weak var patientBloodTypeLabel: UILabel!
    @IBOutlet weak var statusView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(requestDisplay: RequestDisplay) {
        guard let status = BloodRequestStatus(rawValue: requestDisplay.request.status!) else { return }

        switch status {
        case .accepted:
            statusView.backgroundColor = Color.green
        case .declined:
            statusView.backgroundColor = Color.red
        case .pending:
            break
        }

        doctorNameLabel.text = "Dr. \(requestDisplay.name)"
        bloodBagTypeLabel.text = requestDisplay.bloodBagType
        patientBloodTypeLabel.text = requestDisplay.patientBloodType
    }
}
