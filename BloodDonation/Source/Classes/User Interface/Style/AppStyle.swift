//
//  StyleKit.swift
//  {project}
//
//  Created by Botond Magyarosi on 12/03/2017.
//  Copyright © 2017 Halcyon Mobile. All rights reserved.
//

import UIKit

struct AppStyle {

    static func setupAppearance() {
//        let switchControlAppearance = UISwitch.appearance()
//        switchControlAppearance.onTintColor = Colors.switchControlOn
        UINavigationBar.appearance().tintColor = Color.red
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.font: Font.medium(size: .navBar)]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes =
                [.font: Font.bold(size: .largeTitles)]
        }
    }

    struct Colors {
        /// Main accent
        static let mainAccent = Color.lightBlue
        /// Main background
        static let mainBackground = Color.white

        struct Text {
            static let primary = Color.black
        }
    }

    struct Layout {
        static let padding: CGFloat                 = 20.0
    }
}
