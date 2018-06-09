//
//  DonorCell.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

class DonorCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(donor: Donor) {
        nameLabel.text = donor.firstName! + " " + donor.lastName!
        cityLabel.text = "From \(donor.city!)"
        bloodTypeLabel.text = donor.bloodType!

    }

}
