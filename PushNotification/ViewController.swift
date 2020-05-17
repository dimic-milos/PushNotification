//
//  ViewController.swift
//  PushNotification
//
//  Created by Dimic Milos on 4/25/20.
//  Copyright © 2020 Dimic Milos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Notification.Name.accept.onPost { notification in
            print(notification.userInfo)
        }
        
        Notification.Name.reject.onPost { (notification) in
            print(notification.userInfo)
        }
    }


}

