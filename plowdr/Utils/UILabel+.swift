//
//  UILabel+.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

extension UILabel {
  static let mainColor = UIColor(red: 114.0/255.0, green: 169.0/255.0, blue: 209.0/255.0, alpha: 1.0)
  static let secondColor = UIColor(red: 13.0/255.0, green: 39.0/255.0, blue: 62.0/255.0, alpha: 1.0)
  
  func makeDisabled() {
    makeSelected()
    self.isUserInteractionEnabled = false
    self.alpha = 0.5
    self.backgroundColor = UIColor.gray
    self.isUserInteractionEnabled = false
  }
  
  func makeNotSelected() {
    self.isUserInteractionEnabled = true
    self.alpha = 1
    self.layer.borderColor = UILabel.mainColor.cgColor
    self.layer.borderWidth = 5.0
    self.backgroundColor = UIColor.clear
    self.textColor = UILabel.mainColor
  }
  
  func makeSelected() {
//    self.isUserInteractionEnabled = false
    self.alpha = 1
    self.backgroundColor = .clear
    self.layer.borderColor = UIColor.clear.cgColor
    self.layer.borderWidth = 0.0
    self.backgroundColor = UILabel.mainColor
    self.textColor = UILabel.secondColor
  }
  
}
