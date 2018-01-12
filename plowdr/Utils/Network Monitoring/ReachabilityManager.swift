//
//  ReachabilityManager.swift
//  plowdr
//
//  Created by Wilson Balderrama on 1/5/18.
//  Copyright © 2018 plowdr. All rights reserved.
//

import Foundation
import Reachability
import Alamofire

public class ReachibilityManager {
  var isNetworkAvailable: Bool {
    return reachability.connection != Reachability.Connection.none
  }
  var reachability = Reachability()!
  static let shared = ReachibilityManager()
  
  var listeners = [NetworkStatusListener]()
  
  @objc func reachabilityChanged(notification: Notification) {
    let reachability = notification.object as! Reachability
    var plowdrNetworkStates = PlowdrNetworkStatus.notReachable
    
    switch reachability.connection {
    case .cellular:
      print("celular")
      plowdrNetworkStates = .reachable
    case .none:
      print("no connection")
      plowdrNetworkStates = .notReachable
    case .wifi:
      print("wifi")
      plowdrNetworkStates = .reachable
    }
    
    listeners.forEach {
      print($0)
      $0.networkStatusDidChange(status: plowdrNetworkStates)
    }
  }
  
  func startMonitoring() {
    print("startMonitoring")
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.reachabilityChanged(notification:)),
                                           name: Notification.Name.reachabilityChanged,
                                           object: reachability
                                          )
    
    do {
      try reachability.startNotifier()
    } catch {
      print("error could not start the listener: ", error.localizedDescription)
    }
  }
  
  func stopMonitoring() {
    print("stopMonitoring")
    reachability.stopNotifier()
    
    NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
  }
  
  func addListener(listener: NetworkStatusListener) {
    listeners.append(listener)
  }
  
  func removeListener(listener: NetworkStatusListener) {
    listeners = listeners.filter { $0 !== listener }
  }
}
