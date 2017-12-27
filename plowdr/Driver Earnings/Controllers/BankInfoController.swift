//
//  BanknfoController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class BankInfoController: UIViewController {
  
  @IBOutlet weak var updateLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
            updateLabel.isUserInteractionEnabled = true
      updateLabel.addGestureRecognizer(tapGesture)      
    }
  }
  
  @objc func updateLabelTapped() {
    
  }
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
}








































