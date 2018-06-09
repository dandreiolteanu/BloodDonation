//
//  NavigationFlowController.swift
//  {project}
//
//  Created by Tamas Levente on 5/17/17.
//  Copyright © 2017 HalcyonMobile. All rights reserved.
//

import UIKit

class NavigationFlowController: FlowController {

    fileprivate (set) var parentFlow: FlowController?
    fileprivate (set) var flowPresentation: FlowControllerPresentation

    private (set) var navigationController: UINavigationController?

    var mainViewController: UIViewController? {
        return navigationController
    }

    // MARK: - Lifecycle

    required init(from parent: FlowController? = nil, for presentation: FlowControllerPresentation = .custom) {
        parentFlow = parent
        flowPresentation = presentation
    }

    // MARK: - Flow cycle

    // NOTE: You probably want to overwrite this method

    func firstScreen() -> UIViewController {
        return UIViewController()
    }

    func initMainViewController() {
        // don;t do anything if navcontroller is already initialized
        guard navigationController == nil else { return }

        if let parentFlow = parentFlow {
            if flowPresentation == .present {
                // create new
                let root = firstScreen()
                navigationController = UINavigationController(rootViewController: root)
            } else if flowPresentation == .push {
                if let parentNavFlow = parentFlow as? NavigationFlowController {
                    navigationController = parentNavFlow.navigationController
                } else {
                    assertionFailure("Parent flow needs to be a navigation flow for a push presentation!")
                }
            }
        } else {
            if flowPresentation == .push {
                assertionFailure("Need to have a parent flow for a push presentation!")
            } else {
                // create new
                let root = firstScreen()
                navigationController = UINavigationController(rootViewController: root)
            }
        }
    }
}
