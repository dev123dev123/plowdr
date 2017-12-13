//
//  Task.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/12/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation

enum TaskState: String {
  case none
  case assigned
  case enroute
  case completed
}

struct Task {
  
  var id: String
  var jobId: String
  var userId: String
  var driverId: String?
  var state = TaskState.none
  
  var jobType: JobType
  var latitude: Double
  var longitude: Double
  var address: String
  var bestTime: BestTime
  var howWide: String
  var howLong: String
  var howDeepSnow: String
  var obstacles: String
  
  var dateSelected: Date
  
  var isNextSnowFall: Bool
  
  init?(dictionary: [String: Any]) {
    guard
      let id = dictionary["id"] as? String,
      let jobId = dictionary["jobId"] as? String,
      let userId = dictionary["userId"] as? String,
      let stringJobType = dictionary["jobType"] as? String,
      let latitude = dictionary["latitude"] as? Double,
      let longitude = dictionary["longitude"] as? Double,
      let address = dictionary["address"] as? String,
      let stringBesTime = dictionary["bestTime"] as? String,
      let howWide = dictionary["howWide"] as? String,
      let howLong = dictionary["howLong"] as? String,
      let howDeepSnow = dictionary["howDeepSnow"] as? String,
      let obstacles = dictionary["obstacles"] as? String,
      let doubleDateSelected = dictionary["dateSelected"] as? Double,
      let isNextSnowFall = dictionary["isNextSnowFall"] as? Bool
    else {
      return nil
    }
    
    self.id = id
    self.jobId = jobId
    self.userId = userId
    self.jobType = JobType(rawValue: stringJobType) ?? .single
    self.latitude = latitude
    self.longitude = longitude
    self.address = address
    self.bestTime = BestTime(rawValue: stringBesTime) ?? .morning
    self.howWide = howWide
    self.howLong = howLong
    self.howDeepSnow = howDeepSnow
    self.obstacles = obstacles
    
    self.state = TaskState.init(rawValue: dictionary["state"] as? String ?? "") ?? .none
    self.driverId = dictionary["driverId"] as? String
    self.dateSelected = Date.init(timeIntervalSince1970: doubleDateSelected)
    self.isNextSnowFall = isNextSnowFall
  }
}

extension Task {
  
  private static let db = Database.db
  private static let dbTasks = db.collection("tasks")
  
  static func listenNewAndChangesOnTasksForClient(
    userId: String,
    completion: @escaping ([Task]) -> Void
  ) {
    var tasks = [Task]()
    
    let query = dbTasks
                    .whereField("userId", isEqualTo: userId)
                    .order(by: "dateSelected", descending: true)
    
    query.addSnapshotListener { (snap, error) in
      if let documents = snap?.documents {
        tasks = documents.flatMap {
          return Task.init(dictionary: $0.data())
        }
      }
      
      completion(tasks)
    }
    
  }
}





















































