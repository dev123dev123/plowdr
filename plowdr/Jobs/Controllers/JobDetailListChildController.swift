//
//  JobDetailListChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

enum JobListType {
  case howWide
  case howLong
  case howDeepSnow
}

protocol JobDetailEntrySelected {
  func howDeepSnowSelected(_ value: String)
  func howLongSelected(_ value: String)
  func howWideSelected(_ value: String)
}

class JobDetailListChildController: UITableViewController {
//  var jobListType: JobListType?
  var jobListValues = [String: Any]()
  var jobList = [String]()
  var delegate: JobDetailEntrySelected?
  
  let jobDetailCellId = "jobDetailCellId"
  
  var selectedValue: String?
  var selectedValueIndex: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    if let jobListType = jobListValues["jobListType"] as? JobListType {
      switch jobListType {
      case .howDeepSnow:
        jobList = Job.getDeepDrivewaySnowValues()
        break
      case .howLong:
        jobList = Job.getLongDrivewayValues()
        break
      case .howWide:
        jobList = Job.getWideDrivewayValues()
        break
      }
    }
    
    if let jobListValue = jobListValues["jobListValue"] as? String {
      selectedValue = jobListValue
    }
  }
}

extension JobDetailListChildController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return jobList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: jobDetailCellId, for: indexPath)
    let jobDetail = jobList[indexPath.row]
    
    if selectedValue == jobDetail {
      cell.accessoryType = .checkmark
      selectedValueIndex = indexPath.row
    }
    
    cell.textLabel?.text = jobDetail
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let jobListType = jobListValues["jobListType"] as? JobListType else { return }
    
    if let index = selectedValueIndex {
      let indexPath = IndexPath(row: index, section: 0)
      let cell = tableView.cellForRow(at: indexPath)
      cell?.accessoryType = .none
      selectedValue = nil
      selectedValueIndex = nil
    }
    
    let cell = tableView.cellForRow(at: indexPath)
    let value = jobList[indexPath.row]
    
    cell?.accessoryType = .checkmark
    selectedValueIndex = indexPath.row
    
    switch jobListType {
    case .howDeepSnow:
      delegate?.howDeepSnowSelected(value)
      break
    case .howLong:
      delegate?.howLongSelected(value)
      break
    case .howWide:
      delegate?.howWideSelected(value)
      break
    }
    
    dismiss(animated: true)
  }
  
}







































