//
//  UIViewController+Extensions.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 21/05/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

extension UIViewController {

    class var storyboardId: String {
        return "\(self)"
    }

    static func instantiate() -> Self {
        return viewController(viewControllerClass: self)
    }

    private static func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboard = UIStoryboard(name: storyboardId, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Could not instantiate ViewController with class \(self)")
        }
        return viewController
    }
}
