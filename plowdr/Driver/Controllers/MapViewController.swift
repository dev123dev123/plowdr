//
//  MapViewController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/29/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
  var currentTask: Task!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.MapViewChild {
      let destinationVC = segue.destination as? MapViewChildController
      destinationVC?.currentTask = currentTask
    }
  }
  
  @IBAction func closeButtonTouched() {
    dismiss(animated: true)
  }
}
























