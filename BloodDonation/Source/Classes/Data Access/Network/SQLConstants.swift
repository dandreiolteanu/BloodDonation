//
//  SQLConstants.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 22/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation

enum SQLConstants {
    enum Connection {
        static let root = "root"
    }

    static let Account = "Account"
    static let Donor = "Donor"
    static let Nurse = "Nurse"
    static let Doctor = "Doctor"
    static let Patient = "Patient"
    static let BloodBag = "BloodBag"
    static let Request = "Request"

    enum PrimaryKeys {
        static let Account = "Accid"
        static let Donor = "DID"
        static let Nurse = "NID"
        static let Doctor = "DID"
        static let Request = "RID"
        static let BloodBag = "BBID"
    }

    enum ForeignKeys {
        static let Donor = "accid"
        static let Nurse = "Accid"
        static let Doctor = "accid"
    }
}
