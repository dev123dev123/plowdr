//
//  UIViewController+.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/22/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showNotificationAlert(message: String, viewTapped: @escaping (() -> Void)) {
    let storyboard = UIStoryboard.init(name: "NotificationsView", bundle: nil)
    if let notificationController = storyboard.instantiateViewController(withIdentifier: "GenericErrorView") as? GenericErrorController {
      notificationController.alertDescription = message
      notificationController.modalPresentationStyle = .overCurrentContext
      notificationController.okTapped = viewTapped
      notificationController.isPushNotificationAlert = true
      
      present(notificationController, animated: true)
    }
  }
  
  func showErrorAlert(message: String, okTapped: (() -> Void)? = nil) {
    let storyboard = UIStoryboard.init(name: "NotificationsView", bundle: nil)
    if let genericErrorController = storyboard.instantiateViewController(withIdentifier: "GenericErrorView") as? GenericErrorController {
      genericErrorController.alertDescription = message
      genericErrorController.modalPresentationStyle = .overCurrentContext
      genericErrorController.okTapped = okTapped
      
      let topController = UIApplication.shared.keyWindow?.rootViewController
      var rootController = topController
      
      if let root = topController?.presentedViewController {
        rootController = root
      }
      
      rootController?.present(genericErrorController, animated: true)
    }
  }
  
  func createDoneButtonOnKeyboard() -> (UIBarButtonItem, UIToolbar) {
    let toolBarButton = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
    toolBarButton.barStyle = .default

    let barButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)

    var items = [UIBarButtonItem]()
    items.append(barButtonItem)
    items.append(done)

    toolBarButton.items = items
    toolBarButton.sizeToFit()

    return (done, toolBarButton)
  }
  
}



























