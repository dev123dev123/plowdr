//
//  Job.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation
import FirebaseFirestore

//var values = [String: Any]()
//values["id"] = jobDocument.documentID
//values["userId"] = userId
//values["jobType"] = jobType.rawValue
//values["latitude"] = address.latitude
//values["longitude"] = address.longitude
//values["address"] = address.addressLine
//values["dateSelected"] = dateSelected.1
//values["chargeId"] = chargeId
//
//if dateSelected.0 == Strings.UI.newSnowFall {
//  values["isNextSnowFall"] = true
//} else {
//  values["isNextSnowFall"] = false
//}
//values["bestTime"] = bestTime.rawValue
//values["howWide"] = jobDetail.howWide
//values["howLong"] = jobDetail.howLong
//values["howDeepSnow"] = jobDetail.howDeepSnow
//values["obstacles"] = jobDetail.obstacles

enum PlanState: String {
  case active
  case expired
}

struct Job {
//  var id: String
//  var userId: String
//  var jobType: JobType
//  var latitude: Double
//  var longitude: Double
//  var address: String
//  var bestTime: BestTime
//  var howWide: String
//  var howLong: String
//  var howDeepSnow: String
//  var obstacles: String
  
//  var expired: String
  
  
  var date: Date
  var isNextSnowFall: Bool
  var chargeId: String
  
  init?(dictionary: [String: Any]) {
    guard
      let date = dictionary["dateSelected"] as? Double,
      let isNextSnowFall = dictionary["isNextSnowFall"] as? Bool,
      let chargeId = dictionary["chargeId"] as? String
    else {
      return nil
    }
    
    self.date = Date.init(timeIntervalSince1970: date)
    self.isNextSnowFall = isNextSnowFall
    self.chargeId = chargeId
  }
  
}

extension Job {
  
  private static let db = Database.db
  private static let dbJobs = db.collection("jobs")
  
  static func listenNewJobs(
    userId: String,
    completion: @escaping ([Job]) -> Void
  ) {
    let options = QueryListenOptions()
    options.includeQueryMetadataChanges(true)
    
    print("""
      userId: \(userId)
      planState: \(PlanState.active.rawValue)
    """)
    
    var jobs = [Job]()
    let query = dbJobs
                  .whereField("userId", isEqualTo: userId)
                  .whereField("planState", isEqualTo: PlanState.active.rawValue)
                  .order(by: "dateSelected", descending: true)
    query.addSnapshotListener(options: options) { (snap, error) in
      if let documents = snap?.documents {
        jobs = documents.flatMap {
          print($0.metadata.isFromCache)
          return Job.init(dictionary: $0.data())
        }
      }
      
      completion(jobs)
    }
  }
  
  static func save(
    userId: String,
    jobType: JobType,
    address: Address,
    dateSelected: (String, Date),
    bestTime: BestTime,
    jobDetail: JobDetail,
    chargeId: String,
    completion: @escaping (Error?) -> Void
  ) {
    let jobDocument = dbJobs.document()
    
    var values = [String: Any]()
    values["id"] = jobDocument.documentID
    values["jobType"] = jobType.rawValue
    values["dateCreated"] = FieldValue.serverTimestamp()
    
    values["userId"] = userId
    values["latitude"] = address.latitude
    values["longitude"] = address.longitude
    values["address"] = address.addressLine
    values["dateSelected"] = dateSelected.1.timeIntervalSince1970
    values["chargeId"] = chargeId
    
    if dateSelected.0 == Strings.UI.newSnowFall {
      values["isNextSnowFall"] = true
    } else {
      values["isNextSnowFall"] = false
    }
    values["bestTime"] = bestTime.rawValue
    values["howWide"] = jobDetail.howWide
    values["howLong"] = jobDetail.howLong
    values["howDeepSnow"] = jobDetail.howDeepSnow
    values["obstacles"] = jobDetail.obstacles
    values["planState"] = PlanState.active.rawValue
    
    jobDocument.setData(values) { (error) in
      completion(error)
    }
  }
  
  static func getWideDrivewayValues() -> [String] {
    return [
      "1 car",
      "2 cars",
      "3 cars",
      "4 cars",
      "5 cars",
      "6 cars",
      "7 cars",
      "8 cars",
      "9 cars",
      "10 cars"
    ]
  }
  
  static func getLongDrivewayValues() -> [String] {
    return [
      "1 car",
      "2 cars",
      "3 cars",
      "4 cars",
      "5 cars",
      "6 cars",
      "7 cars",
      "8 cars",
      "9 cars",
      "10 cars"
    ]
  }
  
  static func getDeepDrivewaySnowValues() -> [String] {
    return [
      "None currently",
      "1 ft",
      "2 ft",
      "3 ft",
      "4 ft",
      "5 ft"
    ]
  }
  
}




























