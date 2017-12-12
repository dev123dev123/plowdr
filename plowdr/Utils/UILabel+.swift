//
//  UILabel+.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

extension UILabel {
  static let mainColor = UIColor(red: 95.0/255.0, green: 142.0/255.0, blue: 174.0/255.0, alpha: 1.0)
  static let secondColor = UIColor(red: 13.0/255.0, green: 39.0/255.0, blue: 62.0/255.0, alpha: 1.0)
  
  func makeNotSelected() {
    
    self.layer.borderColor = UILabel.mainColor.cgColor
    self.layer.borderWidth = 5.0
    self.layer.backgroundColor = UIColor.clear.cgColor
    self.textColor = UILabel.mainColor
  }
  
  func makeSelected() {
    self.backgroundColor = .clear
    
    self.layer.borderColor = UIColor.clear.cgColor
    self.layer.borderWidth = 0.0
    self.layer.backgroundColor = UILabel.mainColor.cgColor
    self.textColor = UILabel.secondColor
  }
  
}
