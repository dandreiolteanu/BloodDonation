//
//  AppDelegate.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 5/17/17.
//  Copyright © 2017 HalcyonMobile. All rights reserved.
//

import UIKit
import OHMySQL

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var flow: RootFlowController?

    var appEngine: AppEngine = AppEngine()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        appEngine.prepareAppStart()
        AppStyle.setupAppearance()

        let user = OHMySQLUser(userName: "andreiolteanu", password: "andrei13", serverName: "172.20.10.2", dbName: "BloodDonation", port: 8889, socket: "")
        let coordinator = OHMySQLStoreCoordinator(user: user!)
        coordinator.encoding = .UTF8MB4
        coordinator.connect()

        let context = OHMySQLQueryContext()
        context.storeCoordinator = coordinator
        OHMySQLContainer.shared.mainQueryContext = context

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        flow = RootFlowController(window: window)
        flow?.start()

        return true
    }
}
