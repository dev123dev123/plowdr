//
//  Job.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Job {
  
  var date: Date
  var isNextSnowFall: Bool
  
  init?(dictionary: [String: Any]) {
    guard
      let date = dictionary["dateSelected"] as? Date,
      let isNextSnowFall = dictionary["isNextSnowFall"] as? Bool
    else {
      return nil
    }
    
    self.date = date
    self.isNextSnowFall = isNextSnowFall
  }
  
}

extension Job {
  
  private static let db = Database.db
  private static let dbJobs = db.collection("jobs")
  
  static func listenNewJobs(
    userId: String,
    completion: @escaping ([Job]) -> Void
  ) {
    var jobs = [Job]()
    let query = dbJobs.whereField("userId", isEqualTo: userId)
    
    query.addSnapshotListener { (snap, error) in
      if let documents = snap?.documents {
        jobs = documents.flatMap { Job.init(dictionary: $0.data()) }
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
    completion: @escaping (Error?) -> Void
  ) {
    let jobDocument = dbJobs.document()
    
    var values = [String: Any]()
    values["id"] = jobDocument.documentID
    values["userId"] = userId
    values["jobType"] = jobType.rawValue
    values["latitude"] = address.latitude
    values["longitude"] = address.longitude
    values["dateSelected"] = dateSelected.1
    
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




























