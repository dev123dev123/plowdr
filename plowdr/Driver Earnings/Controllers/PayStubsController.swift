//
//  PayStubsController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class PayStubsController: BaseViewController {
  var groupedTasks = [[String: Any]]()
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.PayStubsChild {
      let destinationVC = segue.destination as! PayStubsChildController
      destinationVC.delegate = self
      destinationVC.groupedTasks = groupedTasks
    } else if segue.identifier == StoryboardSegues.PayStubsToEarnings {
      let destinationVC = segue.destination as! EarningsController
      destinationVC.isCurrentEarnings = false
      destinationVC.currentGroupedTask = sender as! [String: Any]
    }
  }
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
}

extension PayStubsController: PayStubsDelegate {
  func didRowTap(groupedTask: [String: Any]) {
    performSegue(withIdentifier: StoryboardSegues.PayStubsToEarnings, sender: groupedTask)
  }
}
