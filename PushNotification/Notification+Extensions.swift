//
//  Notification+Extensions.swift
//  PushNotification
//
//  Created by Dimic Milos on 5/16/20.
//  Copyright © 2020 Dimic Milos. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let accept = Notification.Name("accept")
    static let reject = Notification.Name("reject")
    
    func post(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        center.post(name: self, object: object, userInfo: userInfo)
    }
    
    @discardableResult
    func onPost(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return center.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}
