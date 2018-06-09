//
//  FlowController+Essentials.swift
//  {project}
//
//  Created by Tamas Levente on 5/17/17.
//  Copyright © 2017 HalcyonMobile. All rights reserved.
//

import UIKit
import SafariServices

// INFO:
/* ---
 
 Has some frequently used, essential functionalities already (alert, actionsheet, browser)
 
--- */

extension FlowController {

    // MARK: Navigation

    func popNavigationStack() {
        if let navController = mainViewController as? UINavigationController {
            navController.popViewController(animated: true)
            return
        }

        if let navController = mainViewController?.navigationController {
            navController.popViewController(animated: true)
            return
        }

        print("Can;t pop navigation stack, navigation controller not available")
    }

    // MARK: Alert

    func showAlert(on parent: UIViewController? = nil, title: String?, message: String?, actions: [UIAlertAction]) {
        guard let presenterVC = self.presenter(for: parent) else {
            assertionFailure("Can't show screen, because no main VC is available")
            return
        }

        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            controller.addAction(action)
        }
        presenterVC.present(controller, animated: true, completion: nil)
    }

    // MARK: Actionsheet

    func showActionSheet(on parent: UIViewController? = nil, title: String?, message: String?, actions: [UIAlertAction]) {
        guard let presenterVC = self.presenter(for: parent) else {
            assertionFailure("Can't show screen, because no main VC is available")
            return
        }

        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            controller.addAction(action)
        }
        presenterVC.present(controller, animated: true, completion: nil)
    }

    // MARK: Browser

    func showBrowser(on parent: UIViewController? = nil, with urlString: String) {
        guard let url = URL(string: urlString) else { return }

        guard let presenterVC = self.presenter(for: parent) else {
            assertionFailure("Can't show screen, because no main VC is available")
            return
        }

        let controller = SFSafariViewController(url: url)
        presenterVC.present(controller, animated: true, completion: nil)
    }
}

// MARK: - Convenience

extension FlowController {

    fileprivate func presenter(for parent: UIViewController?) -> UIViewController? {
        var presenter: UIViewController?
        if parent != nil {
            presenter = parent
        } else {
            presenter = mainViewController
        }
        return presenter
    }
}
