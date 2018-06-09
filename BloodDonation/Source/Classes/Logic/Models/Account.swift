//
//  Account.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 01/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation
import OHMySQL

class Account: NSObject, OHMappingProtocol {

    @objc var AID: NSNumber?
    @objc var email: String?
    @objc var password: String?
    @objc var type: NSNumber?

    init(AID: NSNumber, email: String, password: String, type: NSNumber) {
        self.AID = AID
        self.email = email
        self.password = password
        self.type = type
    }

    func mappingDictionary() -> [AnyHashable: Any]! {
        return ["AID": "Accid",
                "email": "Aname",
                "password": "Apass",
                "type": "Adesign"]
    }

    func dictionary() -> [String: Any]! {
        return ["Accid": self.AID!,
                "Aname": self.email!,
                "Apass": self.password!,
                "Adesign": self.type!]
    }

    func mySQLTable() -> String! {
        return "Account"
    }

    func primaryKey() -> String! {
        return "Accid"
    }
}
