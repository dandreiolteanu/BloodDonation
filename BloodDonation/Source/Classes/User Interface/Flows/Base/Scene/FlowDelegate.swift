//
//  FlowDelegate.swift
//  {project}
//
//  Created by Tamas Levente on 5/17/17.
//  Copyright © 2017 HalcyonMobile. All rights reserved.
//

import Foundation

// swiftlint:disable class_delegate_protocol
protocol FlowDelegate: FlowController {
    func didGoBack()
}

extension FlowDelegate {

    func didGoBack() {
        popNavigationStack()
    }
}
