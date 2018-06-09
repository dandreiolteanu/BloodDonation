//
//  AllDonorsViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

class AllDonorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var donors = [Donor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "All Donors"
        navigationItem.largeTitleDisplayMode = .never

        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 76

        DispatchQueue.main.async {
            NurseService.shared.getDonors { donors in
                self.donors = donors
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "donorCell", for: indexPath) as? DonorCell else { return UITableViewCell() }
        cell.configureCell(donor: donors[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let donorId = Int(truncating: donors[indexPath.row].DID!)
            let accountId = Int(truncating: donors[indexPath.row].AID!)
            NurseService.shared.removeDonor(with: donorId, accountId: accountId)
            tableView.beginUpdates()
            donors.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }

}
