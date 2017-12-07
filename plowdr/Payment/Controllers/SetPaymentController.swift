//
//  SetPaymentView.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/22/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import Stripe

class SetPaymentController: UIViewController {
  var delegate: SetJobDetailsDelegate?
  
  @IBOutlet weak var setLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      setLabel.isUserInteractionEnabled = true
      setLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func setLabelTapped() {
    dismiss(animated: true)
    delegate?.paymentSet()
  }
  
  @IBAction func closeButtonTapped() {
    dismiss(animated: true)
  }
}

extension SetPaymentController: STPPaymentContextDelegate {
  func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    
  }
  
  func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
    
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
    
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
    
  }
  
  
}





























