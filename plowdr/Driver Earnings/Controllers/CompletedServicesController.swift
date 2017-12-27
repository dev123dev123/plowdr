//
//  CompletedServicesController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class CompletedServicesController: UIViewController {
  var tasks = [Task]()
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.CompletedServicesChild {
      let destinationVC = segue.destination as? CompletedServicesChildController
      destinationVC?.delegate = self
      destinationVC?.tasks = tasks
    } else if segue.identifier == StoryboardSegues.CompletedServicesToCompletedServiceDetail {
      let destinationVC = segue.destination as? CompletedServiceDetailController
      destinationVC?.currentTask = sender as? Task
    }
  }
}

extension CompletedServicesController: CompletedServicesDelegate {
  func didRowTap(task: Task) {
    performSegue(withIdentifier: StoryboardSegues.CompletedServicesToCompletedServiceDetail, sender: task)
  }
}
