//
//  SetJobDetailController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class SetJobDetailController: UIViewController {
  var delegate: JobDetailsDelegate?
  var childController: SetJobDetailChildController?
  
  @IBOutlet weak var saveLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      saveLabel.isUserInteractionEnabled = true
      saveLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func saveLabelTapped() {
    guard let howWide = childController?.howWideValue else {
      showErrorAlert(message: "Please select how wide value.")
      return
    }
    
    guard let howLong = childController?.howLongValue else {
      showErrorAlert(message: "Please select how long value.")
      return
    }
    
    guard let howDeepSnow = childController?.howDeepSnowValue else {
      showErrorAlert(message: "Please select how deep snow value.")
      return
    }
    
    guard let obstacles = childController?.obstaclesValue else {
      showErrorAlert(message: "Please write something about obstacles value.")
      return
    }
    
    let jobDetail = JobDetail(
      howWide: howWide,
      howLong: howLong,
      howDeepSnow: howDeepSnow,
      obstacles: obstacles
    )
    
    delegate?.jobDetailSent(jobDetail)
    dismiss(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.SetJobDetailChild {
      let destinationVC = segue.destination as? SetJobDetailChildController
      childController = destinationVC
    }
  }
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
}
