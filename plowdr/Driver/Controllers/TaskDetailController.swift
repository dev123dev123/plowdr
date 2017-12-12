//
//  TaskDetailController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class TaskDetailController: UIViewController {
  
  @IBOutlet weak var updateServiceLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateServiceLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      updateServiceLabel.isUserInteractionEnabled = true
      updateServiceLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @objc func updateServiceLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.TaskDetailToUpdateService, sender: nil)
  }
}
