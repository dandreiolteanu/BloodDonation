//
//  AuthenticationViewModel.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 21/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import Foundation

protocol AuthenticationFlowDelegate: class {
    func didTapLogin(for type: UserType, id: Int)
    func didTapSignUp(for type: UserType, id: Int)
}

protocol AuthenticationViewModel: ViewModel {
    var type: UserType { get }
    func didTapLogin(id: Int)
    func didTapSignUp(id: Int)
}

class AuthenticationViewModelImpl: AuthenticationViewModel {
    var type: UserType
    weak var flowDelegate: AuthenticationFlowDelegate?

    init(type: UserType) {
        self.type = type
    }

    func didTapLogin(id: Int) {
        flowDelegate?.didTapLogin(for: type, id: id)
    }

    func didTapSignUp(id: Int) {
        flowDelegate?.didTapSignUp(for: type, id: id)
    }
}
