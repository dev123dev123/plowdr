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
  
  var paymentAmount: Int? {
    didSet {
      if let p = paymentAmount {
        paymentContext.paymentAmount = p
      }
    }
  }
  
  override init() {
    super.init()
    paymentContext.delegate = self
    
  }
  
  func showPaymentFormOnHostViewController() {
//    paymentContext.delegate = self
    paymentContext.pushPaymentMethodsViewController()
  }
  
  func requestPayment() {
    paymentContext.requestPayment()
  }
}


extension STPPaymentContextImplementation: STPPaymentContextDelegate {
  func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    
  }
  
  func paymentContextDidChange(_ paymentContext: STPPaymentContext) {

    if let cardDescription = paymentContext.selectedPaymentMethod?.label {
      if let userId = User.currentUser?.id {
        var values = [String: Any]()
        values["activeCardDescription"] = cardDescription

        User.updateUser(
          byUserId: userId,
          valuesToUpdate: values,
          completion: { (error) in
            User.currentUser?.activeCardDescription = cardDescription
            self.delegate?.paymentSelectionResult(true, cardDescription: cardDescription, error: error)
        })
      }
    }
    
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
    
    guard let customerId = User.currentUser?.customerId else {
      let error = NSError(domain: "Payment", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Customer Id not found."
      ])
      completion(error)
      return
    }
    
    guard let amount = paymentAmount else {
      let error = NSError(domain: "Payment", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Amount not found."
      ])
      completion(error)
      return
    }
    
    User.completeCharge(
      stripeId: paymentResult.source.stripeID,
      amount: amount,
      customerId: customerId) { (error) in
        completion(error)
    }
    
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
    if status == .error {
      delegate?.chargeResult(error: error)
    } else if status == .success {
      delegate?.chargeResult(error: nil)
    } else {
      delegate?.chargeResult(error: error)
    }
  }
}




























