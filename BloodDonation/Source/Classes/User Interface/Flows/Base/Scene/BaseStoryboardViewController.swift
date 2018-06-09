//
//  BaseStoryboardViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 21/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

class BaseStoryboardViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        setupView()
        setupConstraints()
        setupNavigationController()
        setupBindings()
    }

    func setupView() { }
    func setupConstraints() { }
    func setupBindings() { }
    func setupNavigationController() { }
}
