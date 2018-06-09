//
//  AcceptRequestsViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

class AcceptRequestsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var requests = [RequestDisplay]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Blood Requests"
        navigationItem.largeTitleDisplayMode = .never

        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = 170
        tableView.allowsSelection = false
        tableView.dataSource = self

        DispatchQueue.main.async {
            NurseService.shared.getPendingRequsts({ requests in
                self.requests = requests
                self.tableView.reloadData()
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "acceptRequestCell", for: indexPath) as? AcceptRequestCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(requestDisplay: requests[indexPath.row])
        return cell
    }
}

extension AcceptRequestsViewController: AcceptRequestCellDelegate {
    func acceptButtonTapped(on cell: AcceptRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let request = requests[indexPath.row]

        DispatchQueue.main.async {
            NurseService.shared.updateRequest(for: request.request, with: .accepted)
        }

        tableView.beginUpdates()
        requests.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }

    func declineButtonTapped(on cell: AcceptRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let request = requests[indexPath.row]

        DispatchQueue.main.async {
            NurseService.shared.updateRequest(for: request.request, with: .declined)
        }

        tableView.beginUpdates()
        requests.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
