//
//  STPPaymentContextImplementation.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/5/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import Stripe

class STPPaymentContextImplementation: NSObject {
  var paymentContext = StripeConfigurator.createPaymentContext()
  var hostViewController: UIViewController? {
    didSet {
      paymentContext.hostViewController = hostViewController
    }
  }
  var delegate: PaymentContextDelegate?
  
  func showPaymentFormOnHostViewController() {
    paymentContext.pushPaymentMethodsViewController()
    paymentContext.delegate = self
  }
}


extension STPPaymentContextImplementation: STPPaymentContextDelegate {
  func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    print("""
          didFailToLoadWithError

      selectedPaymentMethod: \(String(describing: paymentContext.selectedPaymentMethod))
    """)
  }
  
  func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
    print("""
        paymentContextDidChange

      selectedPaymentMethod: \(String(describing: paymentContext.selectedPaymentMethod))
    """)
    
    if let cardDescription = paymentContext.selectedPaymentMethod?.label {

      if let userId = User.currentUser?.id {
        var values = [String: Any]()
        values["activeCardDescription"] = cardDescription

        User.updateUser(
          byUserId: userId,
          valuesToUpdate: values,
          completion: { (error) in
            User.currentUser?.activeCardDescription = cardDescription
            self.delegate?.paymentResultSent(true, cardDescription: cardDescription, error: error)
        })
      }

    }
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
    print("""
      didCreatePaymentResult
      
      selectedPaymentMethod: \(String(describing: paymentContext.selectedPaymentMethod))
      paymentResult: \(paymentResult)
    """)
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
    print("""
      didFinishWith
      
      selectedPaymentMethod: \(String(describing: paymentContext.selectedPaymentMethod))
      status: \(status)
    """)
  }
}




























