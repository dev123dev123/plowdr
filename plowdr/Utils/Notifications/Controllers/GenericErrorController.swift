//
//  GenericErrorController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/29/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class GenericErrorController: UIViewController {
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var backgroundView: UIView!
  
  var errorMessage: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    backgroundView.layer.cornerRadius = 5.0
    backgroundView.layer.masksToBounds = true
    
    okLabel.layer.cornerRadius = 5.0
    okLabel.layer.masksToBounds = true
    
    messageLabel.text = errorMessage    
  }
  
  @IBOutlet weak var okLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(okLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      okLabel.isUserInteractionEnabled = true
      okLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func okLabelTapped() {
    dismiss(animated: true)
  }
}
