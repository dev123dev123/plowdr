//
//  BaseViewController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 1/3/18.
//  Copyright © 2018 plowdr. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationGot(notification:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
  }
  
  @objc func pushNotificationGot(notification: Notification) {
//    DispatchQueue.main.async {
//      (self as? HomeController)?.hideSideMenu()
//    }
    
    if let message = notification.userInfo?[Strings.PushNotification.messageKey] as? String {
      DispatchQueue.main.async {
        self.showNotificationAlert(message: message) {
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlowNotification"), object: nil, userInfo: notification.userInfo)
        }
      }
    }
  }
}

class BaseViewController: UIViewController {
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationGot(notification:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
  }
  
  @objc func pushNotificationGot(notification: Notification) {
    DispatchQueue.main.async {
      (self as? HomeController)?.hideSideMenu()
    }
    
    if let message = notification.userInfo?[Strings.PushNotification.messageKey] as? String {
      DispatchQueue.main.async {
        self.showNotificationAlert(message: message) {
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlowNotification"), object: nil, userInfo: notification.userInfo)
        }
      }
    }
  }
}




























