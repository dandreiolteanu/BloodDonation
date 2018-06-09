//
//  DoctorService.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit
import OHMySQL

enum BloodRequestStatus: String {
    case pending
    case accepted
    case declined
}

class DoctorService {
    static let shared = DoctorService()
    var doctor: Doctor?

    func getDoctor(for id: Int, completion: @escaping (Response) -> Void) {
        let query = queryFactory.select(SQLConstants.Doctor, condition: "\(SQLConstants.PrimaryKeys.Doctor) = '\(id)'")
        let result = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let resultObject = result as? [[String: Any]] else {
            completion(.failure)
            return
        }

        guard let firstObject = resultObject.first else {
            completion(.failure)
            return
        }

        let doctor = Doctor()
        doctor.map(fromResponse: firstObject)
        self.doctor = doctor
        completion(.success)
    }

    func getPatients(_ completion: @escaping ([Patient]) -> ()) {
        let query = OHMySQLQueryRequestFactory.select(SQLConstants.Patient, condition: nil)
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let responseObject = response as? [[String : Any]] else {
            completion([])
            return
        }

        var patients = [Patient]()
        for patientResponse in responseObject {
            let patient = Patient()
            patient.map(fromResponse: patientResponse)
            patients.append(patient)
        }

        completion(patients)
    }

    func getBloodBags(_ completion: @escaping ([BloodBag]) -> ()) {
        let query = OHMySQLQueryRequestFactory.select(SQLConstants.BloodBag, condition: "isAccepted = '0'")
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let responseObject = response as? [[String : Any]] else {
            completion([])
            return
        }

        var bloodBags = [BloodBag]()
        for bloodBagResponse in responseObject {
            let bloodBag = BloodBag()
            bloodBag.map(fromResponse: bloodBagResponse)
            bloodBags.append(bloodBag)
        }

        completion(bloodBags)
    }

    func getDonor(with id: Int, success: @escaping (Donor) -> Void, failure: @escaping () -> Void) {
        let query = queryFactory.select(SQLConstants.Donor, condition: "\(SQLConstants.PrimaryKeys.Donor) = '\(id)'")
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let responseObject = response as? [[String : Any]] else {
            failure()
            return
        }

        guard let firstObject = responseObject.first else {
            failure()
            return
        }

        let donor = Donor()
        donor.map(fromResponse: firstObject)
        success(donor)
    }

    func createBloodRequest(bloodRequest: [String: Any]) {
        let query = queryFactory.insert(SQLConstants.Request, set: bloodRequest)
        try? mainQueryContext?.execute(query)
    }

    func getRequestMaxId(completion: @escaping (Int) -> Void) {

        let query = queryFactory.select(SQLConstants.Request, condition: nil, orderBy: ["RID"], ascending: false)
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion(-1)
            return
        }
        guard let firstObject = responseObject.first else {
            completion(-1)
            return
        }

        guard let maxId = firstObject["RID"] as? Int else {
            completion(-1)
            return
        }
        completion(maxId + 1)
    }

    func getRequests(_ completion: @escaping ([RequestDisplay]) -> ()) {
        let query = OHMySQLQueryRequestFactory.select(SQLConstants.Request, condition: "Status = 'accepted' OR Status = 'declined'")
        let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let responseObject = response as? [[String : Any]] else {
            completion([])
            return
        }

        let service = NurseService.shared
        var requests = [RequestDisplay]()
        for requestResponse in responseObject {
            let request = Request()
            request.map(fromResponse: requestResponse)
            service.getDoctorName(for: Int(truncating: request.DID!)) { name in
                service.getBloodBagType(for: Int(truncating: request.BBID!), { bloodBagType in
                    service.getPatientBloodType(for: Int(truncating: request.PID!), { patientBloodType in
                        let requestDisplay = RequestDisplay(name: name, bloodBagType: bloodBagType, patientBloodType: patientBloodType, request: request)
                        requests.append(requestDisplay)
                    })
                })
            }
        }
        completion(requests)
    }
}
