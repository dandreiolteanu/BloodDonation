//
//  Donor.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 04/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation
import OHMySQL

class Donor: NSObject, OHMappingProtocol {
    @objc var DID: NSNumber?
    @objc var AID: NSNumber?
    @objc var firstName: String?
    @objc var lastName: String?
    @objc var age: NSNumber?
    @objc var birthDate: String?
    @objc var address: String?
    @objc var city: String?
    @objc var county: String?
    @objc var residence: String?
    @objc var rCity: String?
    @objc var rCounty: String?
    @objc var weight: NSNumber?
    @objc var lastDonation: String?
    @objc var bloodType: String?
    @objc var isVerified: NSNumber?

    init(DID: NSNumber? = nil, AID: NSNumber? = nil, firstName: String? = nil, lastName: String? = nil, age: NSNumber? = nil, birthDate: String? = nil, address: String? = nil,
         city: String? = nil, county: String? = nil, residence: String? = nil, rCity: String? = nil, rCounty: String? = nil,
         weight: NSNumber? = nil, lastDonation: String? = nil, bloodType: String? = nil) {
        self.DID = DID
        self.AID = AID
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.birthDate = birthDate
        self.address = address
        self.city = city
        self.county = county
        self.residence = residence
        self.rCity = rCity
        self.rCounty = rCounty
        self.weight = weight
        self.lastDonation = lastDonation
        self.bloodType = bloodType
        self.isVerified = 0
    }

    func mappingDictionary() -> [AnyHashable: Any]! {
        return ["DID": "DID",
                "AID": "accid",
                "firstName": "DFname",
                "lastName": "DLname",
                "age": "age",
                "birthDate": "BirthDay",
                "address": "adress",
                "city": "ACity",
                "county": "ACounty",
                "residence": "Residence",
                "rCity": "RCity",
                "rCounty": "RCounty",
                "weight": "Weight",
                "lastDonation": "LastDonation",
                "bloodType": "BloodType",
                "isVerified": "isVerified"
        ]
    }

    func dictionary() -> [String: Any]! {
        return ["DID": self.DID!,
                "accid": self.AID!,
                "DFname": self.firstName!,
                "DLname": self.lastName!,
                "age": self.age!,
                "BirthDay": self.birthDate ?? NSDate(),
                "adress": self.address ?? "",
                "ACity": self.city ?? "",
                "ACounty": self.county ?? "",
                "Residence": self.residence ?? "",
                "RCity": self.rCity ?? "",
                "RCounty": self.rCounty ?? "",
                "Weight": self.weight ?? "",
                "LastDonation": self.lastDonation ?? "",
                "BloodType": self.bloodType ?? "",
                "isVerified": self.isVerified ?? 0
        ]
    }

    func mySQLTable() -> String! {
        return "Donor"
    }

    func primaryKey() -> String! {
        return "DID"
    }
}
