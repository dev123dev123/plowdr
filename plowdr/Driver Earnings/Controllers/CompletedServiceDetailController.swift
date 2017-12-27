//
//  CompletedServiceDetailController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class CompletedServiceDetailController: UIViewController {
  var currentTask: Task?
  
  @IBOutlet weak var clientNameLabel: UILabel!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.CompletedServiceDetailChild {
      let destinationVC = segue.destination as? CompletedServiceDetailChildController
      destinationVC?.currentTask = currentTask
    }
  }
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
  
}
