//
//  GenericErrorController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/29/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class GenericErrorController: BaseViewController {
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  var isPushNotificationAlert = false
  
  var alertDescription: String?
  var okTapped: (() -> Void)?
  
  @IBAction func closeButtonTouched() {
    dismiss(animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if isPushNotificationAlert {
      titleLabel.text = "Notifications"
      okLabel.text = "View Plow"
      closeButton.isHidden = false
    } else {
      titleLabel.text = "Error"
      okLabel.text = "OK"
      closeButton.isHidden = true
    }
    
    backgroundView.layer.cornerRadius = 5.0
    backgroundView.layer.masksToBounds = true
    
    okLabel.layer.cornerRadius = 5.0
    okLabel.layer.masksToBounds = true
    
    messageLabel.text = alertDescription
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
    dismiss(animated: true) {
      self.okTapped?()
    }
  }
}
