//
//  UINavigationController+.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/27/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

extension UINavigationController {
  
  func backTo(type: UIViewController.Type) {
    for vc in viewControllers {
      if vc.isKind(of: type) {
        popToViewController(vc, animated: true)
      }
    }
  }
  
}
