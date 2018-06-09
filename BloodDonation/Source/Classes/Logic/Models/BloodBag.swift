//
//  BloodBag.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation
import OHMySQL

class BloodBag: NSObject, OHMappingProtocol {
    @objc var BBID: NSNumber?
    @objc var donorId: NSNumber?
    @objc var donationDay: String?
    @objc var bloodType: String?
    @objc var patientId: NSNumber?
    @objc var donationCenterId: NSNumber?
    @objc var isAccepted: NSNumber?


    init(id: NSNumber? = nil, donorId: NSNumber? = nil, donationDay: String? = nil, bloodType: String? = nil, patientId: NSNumber? = nil, donationCenterId: NSNumber? = nil) {
        self.BBID = id
        self.donorId = donorId
        self.donationDay = donationDay
        self.bloodType = bloodType
        self.patientId = patientId
        self.donationCenterId = donationCenterId
        self.isAccepted = NSNumber(value: 0)
    }

    func mappingDictionary() -> [AnyHashable: Any]! {
        return ["BBID": "BBID",
                "donorId": "donorId",
                "donationDay": "donationDay",
                "bloodType": "bloodType",
                "patientId": "patientId",
                "donationCenterId": "donationCenterId",
                "isAccepted": "isAccepted"]
    }

    func dictionary() -> [String: Any]! {
        return ["BBID": self.BBID!,
                "donorId": self.donorId!,
                "donationDay": self.donationDay!,
                "bloodType": self.bloodType!,
                "patientId": self.patientId ?? NSNumber(value: -1),
                "donationCenterId": self.donationCenterId!,
                "isAccepted": self.isAccepted!]
    }

    func mySQLTable() -> String! {
        return "BloodBag"
    }

    func primaryKey() -> String! {
        return "DID"
    }
}
