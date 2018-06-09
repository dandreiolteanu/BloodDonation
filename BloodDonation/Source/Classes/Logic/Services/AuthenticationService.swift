//
//  AuthenticationService.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 02/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit
import OHMySQL

class AuthenticationService {
    static let shared = AuthenticationService()
    var user: Account?

    func getMaxId(completion: @escaping (Int) -> Void) {

        let query = queryFactory.select(SQLConstants.Account, condition: nil, orderBy: ["Accid"], ascending: false)
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion(-1)
            return
        }
        guard let firstObject = responseObject.first else {
            completion(-1)
            return
        }

        guard let maxId = firstObject["Accid"] as? Int else {
            completion(-1)
            return
        }
        completion(maxId + 1)
    }

    func getMaxIdFor(type: UserType, completion: @escaping (Int) -> Void) {
        var idString = ""
        var tableName = ""

        switch type {
        case .donor:
            idString = SQLConstants.PrimaryKeys.Donor
            tableName = SQLConstants.Donor
        case .nurse:
            idString = SQLConstants.PrimaryKeys.Nurse
            tableName = SQLConstants.Nurse
        case .doctor:
            idString = SQLConstants.PrimaryKeys.Doctor
            tableName = SQLConstants.Doctor
        }

        let query = queryFactory.select(tableName, condition: nil, orderBy: [idString], ascending: false)
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion(-1)
            return
        }
        guard let firstObject = responseObject.first else {
            completion(-1)
            return
        }

        guard let maxId = firstObject[idString] as? Int else {
            completion(-1)
            return
        }
        completion(maxId + 1)
    }

    func createAccount(account: [String: Any], success: @escaping () -> Void, failure: @escaping () -> Void) {
        guard let email = account["Aname"] as? String else { return }
        let emailExistsQuery = queryFactory.selectFirst(SQLConstants.Account, condition: "Aname = '\(email)'")
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(emailExistsQuery)

        guard let responseObject = response else {
            failure()
            return
        }

        if responseObject?.count > 0 {
            failure()
        } else {
            let query = queryFactory.insert(SQLConstants.Account, set: account)
            try? mainQueryContext?.execute(query)
            success()
        }
    }

    func getIdWithAccount(type: UserType, userId: Int, completion: @escaping (Int) -> Void) {
        var idString = ""
        var tableName = ""
        var tableKeyString = ""

        switch type {
        case .donor:
            tableKeyString = SQLConstants.PrimaryKeys.Donor
            idString = SQLConstants.ForeignKeys.Donor
            tableName = SQLConstants.Donor
        case .nurse:
            tableKeyString = SQLConstants.PrimaryKeys.Nurse
            idString = SQLConstants.ForeignKeys.Nurse
            tableName = SQLConstants.Nurse
        case .doctor:
            tableKeyString = SQLConstants.PrimaryKeys.Doctor
            idString = SQLConstants.ForeignKeys.Doctor
            tableName = SQLConstants.Doctor
        }

        let query = queryFactory.select(tableName, condition: "\(idString) = \(userId)")
        let response = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
        guard let responseObject = response as? [[String: Any]] else {
            completion(-1)
            return
        }
        guard let firstObject = responseObject.first else {
            completion(-1)
            return
        }

        guard let id = firstObject[tableKeyString] as? Int else {
            completion(-1)
            return
        }
        completion(id)
    }

    func createDonor(donor: [String: Any]) {
        let query = queryFactory.insert(SQLConstants.Donor, set: donor)
        try? mainQueryContext?.execute(query)
    }

    func createNurse(nurse: [String: Any]) {
        let query = queryFactory.insert(SQLConstants.Nurse, set: nurse)
        try? mainQueryContext?.execute(query)
    }

    func createDoctor(doctor: [String: Any]) {
        let query = queryFactory.insert(SQLConstants.Doctor, set: doctor)
        try? mainQueryContext?.execute(query)
    }

    func logInWith(for type: UserType, email: String, password: String, success: @escaping (Int) -> Void, failure: @escaping () -> Void) {
        let query = queryFactory.selectFirst(SQLConstants.Account, condition: "Aname = '\(email)' AND Apass = '\(password)' AND Adesign = \(type.rawValue)")
        let response  = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)

        guard let responseObject = response as? [[String: Any]] else {
            failure()
            return
        }

        guard let firstObject = responseObject.first else {
            failure()
            return
        }

        guard let id = firstObject["Accid"] as? Int else {
            failure()
            return
        }

        success(id)
    }
}
