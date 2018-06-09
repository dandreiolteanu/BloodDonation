//
//  NotificationConstants.swift
//  {project}
//
//  Created by Botond Magyarosi on 17/07/16.
//  Copyright © 2016 Halcyon Mobile. All rights reserved.
//

import Foundation

typealias NotificationUserInfo = [AnyHashable: Any]

enum Notification: String {
    case userDidLogout

    func post(_ userInfo: NotificationUserInfo? = nil) {
        NotificationCenter.post(name: Foundation.Notification.Name(rawValue: self.rawValue), object: nil, userInfo: userInfo)
    }

    func post(_ userInfo: NotificationUserInfo? = nil, queue: DispatchQueue? = nil, delay: TimeInterval = 0.0) {
        if let queue = queue {
            queue.asyncAfter(deadline: .now() + delay, execute: {
                self.post(userInfo)
            })
        } else {
            post(userInfo)
        }
    }

    func register(_ observer: AnyObject, selector: Selector, obj: AnyObject? = nil) {
        NotificationCenter.addObserver(observer, selector: selector, name: Foundation.Notification.Name(rawValue: self.rawValue), object: obj)
    }

    struct Key {
        static let user         = "user"
    }
}

extension Notification {
    func postOnMainThread(_ userInfo: NotificationUserInfo? = nil, delay: TimeInterval = 0.0) {
        post(userInfo, queue: DispatchQueue.main, delay: delay)
    }
}
