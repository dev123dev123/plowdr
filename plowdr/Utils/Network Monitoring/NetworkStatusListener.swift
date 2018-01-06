//
//  NetworkStatusListener.swift
//  plowdr
//
//  Created by Wilson Balderrama on 1/5/18.
//  Copyright © 2018 plowdr. All rights reserved.
//

import Foundation

public enum NetworkStatus {
  case notReachable
  case reachable
}

public protocol NetworkStatusListener: class {
  func networkStatusDidChange(status: NetworkStatus)
}
