//
//  UINavigationController+NavigationCompletion.swift
//  {project}
//
//  Created by Tamas Levente on 5/17/17.
//  Copyright © 2017 HalcyonMobile. All rights reserved.
//

import UIKit

public extension UINavigationController {

    // Got this from SwifterSwift library: https://github.com/SwifterSwift/SwifterSwift

    // Pop ViewController with completion handler.
    public func popViewController(_ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }
}
