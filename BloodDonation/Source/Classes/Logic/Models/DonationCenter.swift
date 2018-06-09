//
//  DonationCenter.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation
import OHMySQL

class DonationCenter: NSObject, OHMappingProtocol {
    @objc var DCID: NSNumber?
    @objc var address: String?

    func mappingDictionary() -> [AnyHashable: Any]! {
        return ["DCID": "DCID",
                "address": "Address"]
    }

    func dictionary() -> [String: Any]! {
        return ["DCID": self.DCID!,
                "Address": self.address!]
    }


    func mySQLTable() -> String! {
        return "DonationCenter"
    }

    func primaryKey() -> String! {
        return "DCID"
    }
}
