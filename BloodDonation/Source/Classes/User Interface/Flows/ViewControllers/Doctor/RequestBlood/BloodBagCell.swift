//
//  BloodBagCell.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 07/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

class BloodBagCell: UITableViewCell {

    @IBOutlet weak var donorNameLabel: UILabel!
    @IBOutlet weak var lastDonationLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = Color.red
    }

    func configureCell(with donorId: Int, bloodType: String) {
        self.bloodTypeLabel.text = bloodType

            DoctorService.shared.getDonor(with: donorId, success: { donor in
                self.donorNameLabel.text = donor.firstName! + " " + donor.lastName!
                self.lastDonationLabel.text = donor.lastDonation!
            }, failure: {
                self.donorNameLabel.text = "Not Available"
                self.lastDonationLabel.text = "Not Available"
            })
    }
}
