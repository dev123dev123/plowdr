//
//  Address.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/23/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation

struct Address {
  var addressLine: String
  var city: String
  var state: String
  var postalCode: String
  var country: String
  
  var latitude: Double
  var longitude: Double
}

extension Address: CustomStringConvertible {
  var description: String {
    var d = ""
    
    if addressLine != "" {
      d += "\(addressLine), "
    }
    
    if city != "" {
      d += "\(city), "
    }
    
    if state != "" {
      d += "\(state), "
    }
    
    if postalCode != "" {
      d += "\(postalCode), "
    }
    
    if country != "" {
      d += "\(country)"
    }
    
    return d
  }
}
