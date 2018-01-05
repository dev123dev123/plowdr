//
//  TaskDetailChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class TaskDetailChildController: UITableViewController {
  
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
  
  @IBOutlet weak var viewMapLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewMapLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      viewMapLabel.isUserInteractionEnabled = true
      viewMapLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func viewMapLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.TaskDetailChildToMap, sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.TaskDetailChildToMap {
      let destinationVC = segue.destination as? MapViewController
      destinationVC?.currentTask = currentTask
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewMapLabel.layer.cornerRadius = 5.0
    viewMapLabel.layer.masksToBounds = true
    
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






