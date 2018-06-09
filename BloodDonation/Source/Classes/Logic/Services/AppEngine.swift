//
//  AppEngine.swift
//  {project}
//
//  Created by Tamas Levente on 9/22/17.
//  Copyright © 2017 Halcyon Mobile. All rights reserved.
//

import Foundation

class AppEngine {

    // MARK: - Lifecycle

    init() {
//        Logger.setupLogging()
//        Fabric.with([Crashlytics.self])
    }

    // MARK: - Application events

    func prepareAppStart() {
        startDebugToolsIfNeeded()
    }
}

extension AppEngine {

    fileprivate func startDebugToolsIfNeeded() {
//        if AppLaunchConfig.useNetfox {
//            NFX.sharedInstance().start()
//        }
    }
}
