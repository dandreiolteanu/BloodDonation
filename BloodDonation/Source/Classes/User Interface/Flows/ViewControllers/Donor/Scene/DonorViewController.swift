//
//  DonorViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol DonorFlowDelegate: class {
    func didTapLogOutDonor()
}

class DonorViewController: UIViewController {

    weak var flowDelegate: DonorFlowDelegate?
    var userId: Int!


    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var donationStackView: UIStackView!
    @IBOutlet weak var donorNameLabel: UILabel!
    @IBOutlet weak var middleTitleLabel: UILabel!
    private var donor: Donor!

    override func viewDidLoad() {
        super.viewDidLoad()

        DonorService.shared.getDonor(for: userId) { response in
            switch response {
            case .success:
                self.donor = DonorService.shared.donor
                self.donorNameLabel.text = "\(self.donor.firstName!) \(self.donor.lastName!)"
                if self.donor.lastDonation == "" {
                    self.donateButton.alpha = 1.0
                    self.donateButton.isEnabled = true
                    self.donationStackView.alpha = 0.0
                } else {
                    self.donateButton.alpha = 0.5
                    self.donateButton.isEnabled = false
                    self.donationStackView.alpha = 1.0
                }

            case .failure:
                print("failure")
            }
        }
    }

    @IBAction func logOutButtonTapped(_ sender: Any) {
        flowDelegate?.didTapLogOutDonor()
    }

    @IBAction func donateButtonTapped(_ sender: Any) {
        self.donateButton.isEnabled = false
        UIView.animate(withDuration: 0.33, animations: {
            self.donateButton.alpha = 0.5
            self.donationStackView.alpha = 1.0
        })
        
        DispatchQueue.main.async {
            DonorService.shared.getBloodBagMaxId { maxID in
                let bloodBag = BloodBag(id: NSNumber(value: maxID), donorId: self.donor.DID, donationDay: Date().toString(format: .isoDate), bloodType: self.donor.bloodType, patientId: nil, donationCenterId: 0)
                DonorService.shared.createBloodBag(bloodBag: bloodBag.dictionary())
                DonorService.shared.updateLastDonation(id: self.userId, dateString: Date().toString(format: .isoDate))
            }
        }
    }
}
