//
//  SetJobDetailController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class SetJobDetailController: BaseViewController {
  var delegate: JobDetailsDelegate?
  var childController: SetJobDetailChildController?
  
  var jobDetail: JobDetail?
  
  @IBOutlet weak var saveLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      saveLabel.isUserInteractionEnabled = true
      saveLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
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
    
    guard let obstacles = childController?.getObstaclesDescription() else {
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
      
      if let jobDetail = jobDetail {
        destinationVC?.howDeepSnowValue = jobDetail.howDeepSnow
        destinationVC?.howLongValue = jobDetail.howLong
        destinationVC?.howWideValue = jobDetail.howWide
        destinationVC?.obstaclesValue = jobDetail.obstacles
//        destinationVC.descr
      }
    }
  }
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
}
