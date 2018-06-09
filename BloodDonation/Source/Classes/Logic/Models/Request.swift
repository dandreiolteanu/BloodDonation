//
//  Request.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 05/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation
import OHMySQL

class Request: NSObject, OHMappingProtocol {
    @objc var RID: NSNumber?
    @objc var DID: NSNumber?
    @objc var PID: NSNumber?
    @objc var status: String?
    @objc var BBID: NSNumber?

    init(RID: NSNumber? = nil, DID: NSNumber? = nil, PID: NSNumber? = nil, BBID: NSNumber? = nil) {
        self.RID = RID
        self.DID = DID
        self.PID = PID
        self.status = "pending"
        self.BBID = BBID
    }

    func mappingDictionary() -> [AnyHashable: Any]! {
        return ["RID": "RID",
                "DID": "DID",
                "PID": "PID",
                "status": "Status",
                "BBID": "BBID"]
    }

    func dictionary() -> [String: Any]! {
        return ["RID": self.RID!,
                "DID": self.DID!,
                "PID": self.PID!,
                "Status": self.status!,
                "BBID": self.BBID!]
    }


    func mySQLTable() -> String! {
        return "Request"
    }

    func primaryKey() -> String! {
        return "RID"
    }
}
