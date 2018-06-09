//
//  FlowController.swift
//  {project}
//
//  Created by Tamas Levente on 5/17/17.
//  Copyright © 2017 HalcyonMobile. All rights reserved.
//

import UIKit

// INFO:
/* ---

FlowController is the basic type for a regular flowcontroller
 
 Has 3 type of presentation possibility, definable on init:
 - present       - start flow by modal presentation
 - push          - start flow as a subflow of an existing navigation flow, pushing new screens in the same navigationcontroller
 - custom        - start flow customized, by passing in a customPresentation closure

 flow is started with start(), finished with finish()
 Subclasses need to implement the init method,  initMainViewController() and firstScreen() functions
  - init - basicly no need to do anything else in implementation, than assigning arguments to properties
  - initMainViewController() - responsible for creating something that will be used as the mainViewController. navigationcontroller for navigation flows, tabbarcontroller for tabbar flows. Or simple VC for simple, one-screen flows
  - firstScreen() - here is the defined and returned the first screen of the flow. makes sense mostly for navigation stacks, where the result is used as the root VC of the new navigationcontroller
 
--- */

enum FlowControllerPresentation {
    case present, push, custom
}

// MARK: -

protocol FlowController: class {

    var mainViewController: UIViewController? { get }
    var flowPresentation: FlowControllerPresentation { get }
    var parentFlow: FlowController? { get }

    init(from parent: FlowController?, for presentation: FlowControllerPresentation)

    func start(customPresentation: ((_ mainViewController: UIViewController) -> Void)?)
    func finish(customDismiss: ((_ mainViewController: UIViewController) -> Void)?, completion: (() -> Void)?)

    func initMainViewController()
    func firstScreen() -> UIViewController
}

// MARK: - Flow cycle convenience

extension FlowController {

    func start(customPresentation: ((_ mainViewController: UIViewController) -> Void)? = nil) {
        initMainViewController()

        start(with: flowPresentation, customPresentation: customPresentation)
    }

    func finish(customDismiss: ((_ mainViewController: UIViewController) -> Void)? = nil, completion: (() -> Void)? = nil) {
        finish(from: flowPresentation, customDismiss: customDismiss, completion: completion)
    }

    func start(with flowPresentation: FlowControllerPresentation, customPresentation: ((_ mainViewController: UIViewController) -> Void)? = nil) {
        guard let mainVC = mainViewController else {
            assertionFailure("No mainViewController available")
            return
        }

        switch flowPresentation {
        case .present:
            startPresented(main: mainVC)
        case .push:
            startPushed()
        case .custom:
            // call closure
            // WARNING: Add log/warning for missing customPresentation
            if let custom = customPresentation {
                custom(mainVC)
            }
        }
    }

    func finish(from flowPresentation: FlowControllerPresentation, customDismiss: ((_ mainViewController: UIViewController) -> Void)? = nil, completion: (() -> Void)? = nil) {
        switch flowPresentation {
        case .present:
            finishPresented(completion: completion)
        case .push:
            finishPushed(completion: completion)
        case .custom:
            // call closure
            if let custom = customDismiss, let mainVC = mainViewController {
                custom(mainVC)
            }
        }
    }

    fileprivate func startPresented(main: UIViewController) {
        guard let parentFlow = parentFlow else {
            assertionFailure("parentFlow is nil when trying to present flow")
            return
        }

        parentFlow.mainViewController?.present(main, animated: true, completion: nil)
    }

    fileprivate func finishPresented(completion: (() -> Void)?) {
        guard let parentFlow = parentFlow else {
            assertionFailure("parentFlow is nil when trying to finish flow")
            return
        }

        parentFlow.mainViewController?.dismiss(animated: true, completion: completion)
    }

    fileprivate func startPushed() {
        if let parentNavigationController = parentFlow?.mainViewController as? UINavigationController {
            let vc = firstScreen()
            parentNavigationController.pushViewController(vc, animated: true)
        } else {
            assertionFailure("ParentFlow's main view controller is not a UINavigationController, but presentation style is push")
        }
    }

    fileprivate func finishPushed(completion: (() -> Void)?) {
        guard let parentNavigationController = parentFlow?.mainViewController as? UINavigationController else {
            assertionFailure("parentFlow is nil, or it's main controller is not a navigationcontroller when trying to push flow")
            return
        }

        parentNavigationController.popViewController(completion)
    }
}
