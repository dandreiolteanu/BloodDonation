//
//  DoctorRequestsViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 07/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

class DoctorRequestsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var requests = [RequestDisplay]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Blood Requests"
        navigationItem.largeTitleDisplayMode = .never

        tableView.rowHeight = 110
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        tableView.dataSource = self

        DispatchQueue.main.async {
            DoctorService.shared.getRequests { requests in
                self.requests = requests
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "doctorRequestsCell", for: indexPath) as? DoctorRequestsCell else { return UITableViewCell() }
        cell.configureCell(requestDisplay: requests[indexPath.row])
        return cell
    }
}
