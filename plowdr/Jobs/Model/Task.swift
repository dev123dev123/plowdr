//
//  Task.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/12/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseFirestore

enum TaskState: Int {
  case none = 0
  case assigned = 1
  case enroute = 2
  case plowing = 3
  case completed = 4
  
  func getStringValue() -> String {
    switch self {
    case .none:
      return "None"
    case .assigned:
      return "Assigned"
    case .enroute:
      return "En Route"
    case .plowing:
      return "Plowing"
    case .completed:
      return "Completed"
    }
  }
}

struct Task {
  
  var id: String
  var jobId: String
  var userId: String
  var driverId: String?
  var clientName: String
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
  var payment: Int = 0
  
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
      let isNextSnowFall = dictionary["isNextSnowFall"] as? Bool,
      let clientName = dictionary["clientName"] as? String
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
    
    self.state = TaskState.init(rawValue: dictionary["state"] as? Int ?? 0) ?? .none
    self.driverId = dictionary["driverId"] as? String
    self.dateSelected = Date.init(timeIntervalSince1970: doubleDateSelected / 1000.0)
    self.isNextSnowFall = isNextSnowFall
    self.clientName = clientName
    self.payment = dictionary["payment"] as? Int ?? 0
  }
}

extension Task {
  private static let db = Database.db
  private static let dbTasks = db.collection("tasks")
  
  static func getTasksOrderedByHalfMonths(
    byDriverId driverId: String,
    completion: @escaping (Error?, [[String: Any]]) ->  Void
  ) {
    let urlString = Strings.Server.getTasksOrderedByHalfMonthsURLString
    
    var parameters = [String: Any]()
    parameters["driverId"] = driverId
    
    Alamofire.request(
      urlString,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    )
      .responseJSON(completionHandler: { (response) in
        if response.response?.statusCode == 200 {
          if
            let json = response.value as? [String: Any],
            let tasks = json["tasks"] as? [[String: Any]]
          {
            completion(nil, tasks)
            return
          }
          
          let error = NSError(
            domain: "Payment",
            code: 0,
            userInfo: [
              NSLocalizedDescriptionKey: "Charge Id was not sent."
            ])
          completion(error, [[:]])
        } else {
          var errorMessage = "Someting happened, try again please."
          
          if
            let json = response.result.value as? [String: Any],
            let message = json["message"] as? String
          {
            errorMessage = message
          }
          
          let error = NSError(
            domain: "Payment",
            code: 0,
            userInfo: [
              NSLocalizedDescriptionKey: errorMessage
            ])
          completion(error, [[:]])
        }
    })
  }
  
  static func changeState(
    taskId: String,
    newState: TaskState,
    completion: @escaping (Error?) -> Void
  ) {
    let taskDocument = dbTasks.document(taskId)
    
    var fields = [String: Any]()
    fields["state"] = newState.rawValue
    
    taskDocument.updateData(fields) { (error) in
      completion(error)
    }
  }
  
  static func listenChangesOnTaskBy(
    taskId: String,
    completion: @escaping (Error?, Task?) -> Void
  ) -> Any {
    return dbTasks
      .document(taskId)
      .addSnapshotListener { (snap, error) in
        
        guard let document = snap else {
          completion(error!, nil)
          return
        }
        
        if document.exists {
          completion(nil, Task.init(dictionary: document.data()))
        } else {
          let error = NSError(domain: "Task", code: 0, userInfo: [NSLocalizedDescriptionKey: "Task not found."])
          completion(error, nil)
        }
    }
  }
  
  static func unlistenChangesOnTaskBy(listener: Any?) {
    let firestoreListener = listener as? ListenerRegistration
    firestoreListener?.remove()
  }
  
  static func listenNewAndChangesOnTasksForDriver(
    driverId: String,
    completion: @escaping ([Task]) -> Void
  ) {
    var tasks = [Task]()
    let query = dbTasks
                      .whereField("driverId", isEqualTo: driverId)
                      .whereField("state", isGreaterThan: 0)
                      .order(by: "state")
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
  
  static func getTitlesBy(taskState: TaskState, dateSelected: Date? = nil) -> (String, String) {
    
    switch taskState {
    case .none:
      return Strings.UI.TaskState.noneTitles
    case .assigned:
      return Strings.UI.TaskState.assignedTitles
    case .enroute:
      return Strings.UI.TaskState.enrouteTitles
    case .plowing:
      return Strings.UI.TaskState.plowingTitles
    case .completed:
      return Strings.UI.TaskState.completedTitles
    }
  }
  
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





















































