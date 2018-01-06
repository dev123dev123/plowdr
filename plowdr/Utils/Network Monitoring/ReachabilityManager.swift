//
//  ReachabilityManager.swift
//  plowdr
//
//  Created by Wilson Balderrama on 1/5/18.
//  Copyright © 2018 plowdr. All rights reserved.
//

import Foundation

public class ReachibilityManager {
  
  static let shared = ReachibilityManager()
  
  var listeners = [NetworkStatusListener]()
  
  func startMonitoring() {
    
  }
  
  func stopMonitoring() {
    
  }
  
  func addListener(listener: NetworkStatusListener) {
    listeners.append(listener)
  }
  
  func removeListener(listener: NetworkStatusListener) {
    listeners = listeners.filter { $0 !== listener }
  }
}
