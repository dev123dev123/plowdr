//
//  StripeConfigurator.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/5/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation
import Stripe

struct StripeConfigurator {
//  static var customer: STPCustomerContext?
//
//  static func initCustomer() {
//    customer = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
//  }
  
  static func createPaymentContext() -> STPPaymentContext {
    let config = STPPaymentConfiguration.shared()
    config.publishableKey = Strings.Keys.Stripe.API_PublisableKey
    config.companyName = Strings.companyName
    config.additionalPaymentMethods = .all
    
    let customerContext = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
    
    let paymentContext = STPPaymentContext(
      customerContext: customerContext,
      configuration: config,
      theme: .default()
    )
    
    paymentContext.paymentCurrency = Strings.paymentCurrency
    
    return paymentContext
  }
}
