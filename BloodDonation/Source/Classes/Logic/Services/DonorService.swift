//
//  DonorService.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit
import OHMySQL

enum Response {
    case success
    case failure
}

class DonorService {
    static let shared = DonorService()
    var donor: Donor?

    func getDonor(for id: Int, completion: @escaping (Response) -> Void) {
        let query = queryFactory.select(SQLConstants.Donor, condition: "DID = '\(id)'")
        let result = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let resultObject = result as? [[String: Any]] else {
            completion(.failure)
            return
        }

        guard let firstObject = resultObject.first else {
            completion(.failure)
            return
        }

        let donor = Donor()
        donor.map(fromResponse: firstObject)
        self.donor = donor
        completion(.success)
    }

    func createBloodBag(bloodBag: [String: Any]) {
        let query = queryFactory.insert(SQLConstants.BloodBag, set: bloodBag)
        try? mainQueryContext?.execute(query)
    }

    func getBloodBagMaxId(completion: @escaping (Int) -> Void) {

        let query = queryFactory.select(SQLConstants.BloodBag, condition: nil, orderBy: ["BBID"], ascending: false)
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion(0)
            return
        }
        guard let firstObject = responseObject.first else {
            completion(0)
            return
        }

        guard let maxId = firstObject["BBID"] as? Int else {
            completion(0)
            return
        }
        completion(maxId + 1)
    }

    func updateLastDonation(id: Int, dateString: String) {
        let query = queryFactory.update(SQLConstants.Donor, set: ["LastDonation": dateString], condition: "\(SQLConstants.PrimaryKeys.Donor) = \(id)")
        try? mainQueryContext?.execute(query)
    }
}
