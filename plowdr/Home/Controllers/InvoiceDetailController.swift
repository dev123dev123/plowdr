//
//  InvoiceDetailController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class InvoiceDetailController: UIViewController {
  var currentTask: Task!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.InvoiceDetailChild {
      let destinationVC = segue.destination as? InvoiceDetailChildController
      destinationVC?.currentTask = currentTask
    }
  }
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
}






































