//
//  JobDetailController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/1/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class JobDetailController: UIViewController {
  var currentTask: Task!
  var formatter = DateFormatter()
  
  @IBOutlet weak var titleLabel: UILabel!
  var childController: JobDetailChildController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formatter.dateFormat = "E, MMM dd"
    
    setUIValues()
  }
  
  func setUIValues() {
    titleLabel.text = "Loading.."
   
    if currentTask.isNextSnowFall {
      titleLabel.text = Strings.UI.TaskState.isNextSnowFall.0
    } else {
      titleLabel.text = formatter.string(from: currentTask.dateSelected)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.JobDetailChild {
      let destinationVC = segue.destination as? JobDetailChildController
      childController = destinationVC
      childController?.currentTask = currentTask
      childController?.delegate = self
    }
  }
  
  @IBAction func cancelButtonTouched() {
    dismiss(animated: true)
  }
}

extension JobDetailController: JobDetailDelegate {
  func taskChanged(task: Task) {
    currentTask = task
    self.setUIValues()
  }
}



































