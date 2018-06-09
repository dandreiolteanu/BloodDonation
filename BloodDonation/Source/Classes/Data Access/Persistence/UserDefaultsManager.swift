//
//  UserDefaultsManager.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 06/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    private let userDefaults = UserDefaults.standard
    static let shared = UserDefaultsManager()

    private var donorId: Int {
        get {
            return userDefaults.integer(forKey: "donorId")
        } set {
            userDefaults.set(newValue, forKey: "donorId")
        }
    }

    private var isDonorLoggedIn: Bool {
        get {
            return userDefaults.bool(forKey: "isDonorLoggedIn")
        } set {
            userDefaults.set(newValue, forKey: "isDonorLoggedIn")
        }
    }

    private var nurseId: Int {
        get {
            return userDefaults.integer(forKey: "nurseId")
        } set {
            userDefaults.set(newValue, forKey: "nurseId")
        }
    }

   private  var isNurseLoggedIn: Bool {
        get {
            return userDefaults.bool(forKey: "isNurseLoggedIn")
        } set {
            userDefaults.set(newValue, forKey: "isNurseLoggedIn")
        }
    }

   private  var doctorId: Int {
        get {
            return userDefaults.integer(forKey: "doctorId")
        } set {
            userDefaults.set(newValue, forKey: "doctorId")
        }
    }

   private  var isDoctorLoggedIn: Bool {
        get {
            return userDefaults.bool(forKey: "isDoctorLoggedIn")
        } set {
            userDefaults.set(newValue, forKey: "isDoctorLoggedIn")
        }
    }

    func getDonorId() -> Int? {
        if isDonorLoggedIn {
            return donorId
        }
        return nil
    }

    func getNurseId() -> Int? {
        if isNurseLoggedIn {
            return nurseId
        }
        return nil
    }

    func getDoctorId() -> Int? {
        if isDoctorLoggedIn {
            return doctorId
        }
        return nil
    }

    func setDonorId(newValue: Int) {
        isDonorLoggedIn = true
        donorId = newValue
    }

    func setNurseId(newValue: Int) {
        isNurseLoggedIn = true
        nurseId = newValue
    }

    func setDoctorId(newValue: Int) {
        isDoctorLoggedIn = true
        doctorId = newValue
    }

    func clear() {
        userDefaults.removeObject(forKey: "donorId")
        userDefaults.removeObject(forKey: "nurseId")
        userDefaults.removeObject(forKey: "doctorId")
        userDefaults.removeObject(forKey: "isDonorLoggedIn")
        userDefaults.removeObject(forKey: "isNurseLoggedIn")
        userDefaults.removeObject(forKey: "isDoctorLoggedIn")
    }
}
