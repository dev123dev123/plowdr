//
//  CompletedServiceDetailChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit


class CompletedServiceDetailChildController: UITableViewController {
  
  var currentTask: Task!
  let formatter = DateFormatter()
  
  @IBOutlet weak var jobTypeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateSelectedLabel: UILabel!
  @IBOutlet weak var bestTimeLabel: UILabel!
  @IBOutlet weak var howWideLabel: UILabel!
  @IBOutlet weak var howLongLabel: UILabel!
  @IBOutlet weak var howDeepSnowLabel: UILabel!
  @IBOutlet weak var obstaclesTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = "E, MMM dd"
    
    jobTypeLabel.text = currentTask.jobType.rawValue
    addressLabel.text = currentTask.address
    dateSelectedLabel.text = formatter.string(from: currentTask.dateSelected)
    bestTimeLabel.text = currentTask.bestTime.rawValue
    howWideLabel.text = currentTask.howWide
    howLongLabel.text = currentTask.howLong
    howDeepSnowLabel.text = currentTask.howDeepSnow
    obstaclesTextView.text = currentTask.obstacles
  }
  
}























