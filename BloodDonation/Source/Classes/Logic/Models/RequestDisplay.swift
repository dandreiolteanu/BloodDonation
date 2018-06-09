//
//  RequestDisplay.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 08/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation

class RequestDisplay {
    var name: String
    var bloodBagType: String
    var patientBloodType: String
    var request: Request

    init(name: String, bloodBagType: String, patientBloodType: String, request: Request) {
        self.name = name
        self.bloodBagType = bloodBagType
        self.patientBloodType = patientBloodType
        self.request = request
    }
}
