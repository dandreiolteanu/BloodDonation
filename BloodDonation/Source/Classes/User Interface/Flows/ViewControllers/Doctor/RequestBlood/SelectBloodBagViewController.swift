//
//  SelectBloodBagViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 07/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol SelectBloodBagFlowDelegate: class {
    func didRequestBloodButtonPressed()
}

class SelectBloodBagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var flowDelegate: SelectBloodBagFlowDelegate?
    var patient: Patient!
    var doctor: Doctor!
    var bloodBag: BloodBag?

    var bloodBags = [BloodBag]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var requestButtonBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        requestButtonBottomConstraint.constant = -120
        navigationItem.title = "Blood Bags"

        patientNameLabel.text = patient.name!
        bloodTypeLabel.text = patient.bloodType!

        tableView.rowHeight = 85
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self

        DispatchQueue.main.async {
            DoctorService.shared.getBloodBags { bloodBags in
                self.bloodBags = bloodBags
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func requestBloodButtonTapped(_ sender: Any) {
        guard let bloodBag = bloodBag else { return }
        flowDelegate?.didRequestBloodButtonPressed()

        DispatchQueue.main.async {
            DoctorService.shared.getRequestMaxId(completion: { id in
                let bloodRequest = Request(RID: NSNumber(value: id), DID: self.doctor.DID!, PID: self.patient.PID!, BBID: bloodBag.BBID!)
                DoctorService.shared.createBloodRequest(bloodRequest: bloodRequest.dictionary())
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bloodBags.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bloodBagCell", for: indexPath) as? BloodBagCell else { return UITableViewCell() }
        cell.configureCell(with: Int(truncating: bloodBags[indexPath.row].donorId!), bloodType: bloodBags[indexPath.row].bloodType!)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bloodBag = bloodBags[indexPath.row]

        if requestButtonBottomConstraint.constant != 0 {
            requestButtonBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.44, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
