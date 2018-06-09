//
//  AcceptRequestCell.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 07/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol AcceptRequestCellDelegate: class {
    func acceptButtonTapped(on cell: AcceptRequestCell)
    func declineButtonTapped(on cell: AcceptRequestCell)
}

class AcceptRequestCell: UITableViewCell {

    weak var delegate: AcceptRequestCellDelegate?

    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var bloodBagTypeLabel: UILabel!
    @IBOutlet weak var patientBloodTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configureCell(requestDisplay: RequestDisplay) {
        doctorNameLabel.text = "Dr. \(requestDisplay.name)"
        bloodBagTypeLabel.text = requestDisplay.bloodBagType
        patientBloodTypeLabel.text = requestDisplay.patientBloodType
    }

    @IBAction func acceptButtonTapped(_ sender: Any) {
        delegate?.acceptButtonTapped(on: self)
    }

    @IBAction func declineButtonTapped(_ sender: Any) {
        delegate?.declineButtonTapped(on: self)
    }
}
