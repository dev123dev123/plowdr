//
//  JobDetailController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/1/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class JobDetailController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  var childController: JobDetailChildController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUIValues()
  }
  
  func setUIValues() {
    titleLabel.text = "November 30, 2017"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.JobDetailChild {
      let destinationVC = segue.destination as? JobDetailChildController
      childController = destinationVC
    }
  }
  
  @IBAction func cancelButtonTouched() {
    dismiss(animated: true)
  }
}
