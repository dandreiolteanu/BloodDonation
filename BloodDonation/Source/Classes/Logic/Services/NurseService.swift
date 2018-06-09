//
//  NurseService.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit
import OHMySQL

class NurseService {
    static let shared = NurseService()
    var nurse: Nurse?

    func getNurse(for id: Int, completion: @escaping (Response) -> Void) {
        let query = queryFactory.select(SQLConstants.Nurse, condition: "NID = '\(id)'")
        let result = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let resultObject = result as? [[String: Any]] else {
            completion(.failure)
            return
        }

        guard let firstObject = resultObject.first else {
            completion(.failure)
            return
        }

        let nurse = Nurse()
        nurse.map(fromResponse: firstObject)
        self.nurse = nurse
        completion(.success)
    }

    func getDonors(_ completion: @escaping ([Donor]) -> ()) {
        let query = OHMySQLQueryRequestFactory.select(SQLConstants.Donor, condition: nil)
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let responseObject = response as? [[String : Any]] else {
            completion([])
            return
        }

        var donors = [Donor]()
        for donorResponse in responseObject {
            let donor = Donor()
            donor.map(fromResponse: donorResponse)
            donors.append(donor)
        }

        completion(donors)
    }

    func removeDonor(with id: Int, accountId: Int) {
        let query = queryFactory.delete(SQLConstants.Donor, condition: "\(SQLConstants.PrimaryKeys.Donor) = \(id)")
        try? mainQueryContext?.execute(query)

        let queryAccount = queryFactory.delete(SQLConstants.Account, condition: "\(SQLConstants.PrimaryKeys.Account) = \(accountId)")
        try? mainQueryContext?.execute(queryAccount)
    }

    func addPatient(patient: [String: Any]) {
        let query = queryFactory.insert(SQLConstants.Patient, set: patient)
        try? mainQueryContext?.execute(query)
    }

    func getPatientMaxId(completion: @escaping (Int) -> Void) {

        let query = queryFactory.select(SQLConstants.Patient, condition: nil, orderBy: ["PID"], ascending: false)
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion(0)
            return
        }
        guard let firstObject = responseObject.first else {
            completion(0)
            return
        }

        guard let maxId = firstObject["PID"] as? Int else {
            completion(0)
            return
        }
        completion(maxId + 1)
    }

    func getPendingRequsts(_ completion: @escaping ([RequestDisplay]) -> ()) {
        let query = OHMySQLQueryRequestFactory.select(SQLConstants.Request, condition: "Status = 'pending'")
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let responseObject = response as? [[String : Any]] else {
            completion([])
            return
        }

        var requests = [RequestDisplay]()
        for requestResponse in responseObject {
            let request = Request()
            request.map(fromResponse: requestResponse)
            getDoctorName(for: Int(truncating: request.DID!)) { name in
                self.getBloodBagType(for: Int(truncating: request.BBID!), { bloodBagType in
                    self.getPatientBloodType(for: Int(truncating: request.PID!), { patientBloodType in
                        let requestDisplay = RequestDisplay(name: name, bloodBagType: bloodBagType, patientBloodType: patientBloodType, request: request)
                        requests.append(requestDisplay)
                    })
                })
            }
        }
        completion(requests)
    }

    func getBloodBagType(for id: Int, _ completion: (String) -> Void) {
        let query = queryFactory.select(SQLConstants.BloodBag, condition: "BBID = '\(id)'")
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion("")
            return
        }
        guard let firstObject = responseObject.first else {
            completion("")
            return
        }

        guard let bloodType = firstObject["bloodType"] as? String else {
            completion("")
            return
        }
        completion(bloodType)
    }

    func getDoctorName(for id: Int, _ completion: (String) -> Void) {
        let query = queryFactory.select(SQLConstants.Doctor, condition: "DID = '\(id)'")
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion("")
            return
        }
        guard let firstObject = responseObject.first else {
            completion("")
            return
        }

        guard let name = firstObject["DFname"] as? String else {
            completion("")
            return
        }
        completion(name)
    }

    func getPatientBloodType(for id: Int, _ completion: (String) -> Void) {
        let query = queryFactory.select(SQLConstants.Patient, condition: "PID = '\(id)'")
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion("")
            return
        }
        guard let firstObject = responseObject.first else {
            completion("")
            return
        }

        guard let bloodType = firstObject["BloodType"] as? String else {
            completion("")
            return
        }
        completion(bloodType)
    }

    func updateRequest(for request: Request, with status: BloodRequestStatus) {
        guard let requestId = request.RID as? Int else { return }
        
        let query = queryFactory.update(SQLConstants.Request, set: ["Status": status.rawValue], condition: "\(SQLConstants.PrimaryKeys.Request) = \(requestId)")
        try? mainQueryContext?.execute(query)

        if status == .accepted {
            guard let bloodBagId = request.BBID as? Int else { return }
            let updateQuery = queryFactory.update(SQLConstants.BloodBag, set: ["isAccepted": 1], condition: "\(SQLConstants.PrimaryKeys.BloodBag) = '\(bloodBagId)'")
            try? mainQueryContext?.execute(updateQuery)
        }
    }
}
