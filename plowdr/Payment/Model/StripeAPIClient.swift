//
//  StripeAPIClient.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/5/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripeAPIClient: NSObject, STPEphemeralKeyProvider {
  static let sharedClient = StripeAPIClient()
  
  func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
    if let userId = User.currentUser?.customerId {
      User.createEphimeralKey(
        userId: userId,
        apiVersion: apiVersion) { (json, error) in
          completion(json, error)
      }
    }
  }
  
  
}
