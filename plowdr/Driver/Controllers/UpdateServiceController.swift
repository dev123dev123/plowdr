//
//  UpdateServiceController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class UpdateServiceController: UIViewController {
  @IBOutlet weak var updateLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      updateLabel.isUserInteractionEnabled = true
      updateLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  var childController: UpdateServiceChildController?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.UpdateServiceChild {
      let destinationVC = segue.destination as? UpdateServiceChildController
      childController = destinationVC
    }
  }
  
  @IBAction func closeButtonTapped(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @objc func updateLabelTapped() {
//    let enrouteSelected = childController?.isEnrouteSelected
//    let currrentlyPlowingSelected = childController?.isCurrentlyPlowingSelected
//    let completedSelected = childController?.isCompletedSelected
    dismiss(animated: true)
    
  }
}







































