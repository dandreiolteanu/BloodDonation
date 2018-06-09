//
//  Patient.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation
import OHMySQL

class Patient: NSObject, OHMappingProtocol {
    @objc var PID: NSNumber?
    @objc var name: String?
    @objc var bloodType: String?

    init(PID: NSNumber? = nil, name: String? = nil, bloodType: String? = nil) {
        self.PID = PID
        self.name = name
        self.bloodType = bloodType
    }

    func mappingDictionary() -> [AnyHashable: Any]! {
        return ["PID": "PID",
                "name": "name",
                "bloodType": "BloodType"]
    }

    func dictionary() -> [String: Any]! {
        return ["PID": self.PID!,
                "name": self.name!,
                "BloodType": self.bloodType!]
    }


    func mySQLTable() -> String! {
        return "Patient"
    }

    func primaryKey() -> String! {
        return "PID"
    }
}
