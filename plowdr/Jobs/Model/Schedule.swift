//
//  Schedule.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/23/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation

enum BestTime : String {
  case morning
  case afternoon
}

struct Schedule {
  var date: Date
  var bestTime: BestTime
}
