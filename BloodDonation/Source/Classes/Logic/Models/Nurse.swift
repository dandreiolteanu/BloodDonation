//
//  Nurse.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation
import OHMySQL

class Nurse: NSObject, OHMappingProtocol {
    @objc var NID: NSNumber?
    @objc var name: String?
    @objc var AID: NSNumber?

    init(NID: NSNumber? = nil, name: String? = nil, AID: NSNumber? = nil) {
        self.NID = NID
        self.name = name
        self.AID = AID
    }

    func mappingDictionary() -> [AnyHashable: Any]! {
        return ["NID": "NID",
                "name": "Nname",
                "AID": "Accid"]
    }

    func dictionary() -> [String: Any]! {
        return ["NID": self.NID!,
                "Nname": self.name!,
                "Accid": self.AID!]
    }


    func mySQLTable() -> String! {
        return "Nurse"
    }

    func primaryKey() -> String! {
        return "NID"
    }
}
