//
//  UIViewController+.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/22/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showErrorAlert(message: String, okTapped: (() -> Void)? = nil) {
    let storyboard = UIStoryboard.init(name: "NotificationsView", bundle: nil)
    if let genericErrorController = storyboard.instantiateViewController(withIdentifier: "GenericErrorView") as? GenericErrorController {
      genericErrorController.errorMessage = message
      genericErrorController.modalPresentationStyle = .overCurrentContext
      genericErrorController.okTapped = okTapped
      
      present(genericErrorController, animated: true)
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



























