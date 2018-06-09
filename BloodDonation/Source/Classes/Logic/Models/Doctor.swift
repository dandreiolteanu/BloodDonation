//
//  Doctor.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation
import OHMySQL

class Doctor: NSObject, OHMappingProtocol {
    @objc var DID: NSNumber?
    @objc var name: String?
    @objc var AID: NSNumber?

    init(DID: NSNumber? = nil, name: String? = nil, AID: NSNumber? = nil) {
        self.DID = DID
        self.name = name
        self.AID = AID
    }

    func mappingDictionary() -> [AnyHashable: Any]! {
        return ["DID": "DID",
                "name": "DFname",
                "AID": "accid"]
    }

    func dictionary() -> [String: Any]! {
        return ["DID": self.DID!,
                "DFname": self.name!,
                "accid": self.AID!]
    }


    func mySQLTable() -> String! {
        return "Doctor"
    }

    func primaryKey() -> String! {
        return "DID"
    }
}
