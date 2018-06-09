//
//  FlowController+CustomAlerts.swift
//  {project}
//
//  Created by Tamas Levente on 5/17/17.
//  Copyright © 2017 HalcyonMobile. All rights reserved.
//

import UIKit

extension FlowController {

    func showErrorAlert(for error: Error) {
        // of course, this needs to be dynamic, error-dependent
        let title = "Error"
        let message = "Ooops, something went wrong"
        showMessage(on: nil, title: title, message: message)
    }

    func showMessage(on parent: UIViewController? = nil, title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        showAlert(on: parent, title: title, message: message, actions: [okAction])
    }
}

extension UIViewController {
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }


}
