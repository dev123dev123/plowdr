//
//  UpdateServiceChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class UpdateServiceChildController: UITableViewController {
  var currentTask: Task!
  
  @IBOutlet weak var enrouteLabel: UILabel!
  @IBOutlet weak var currentlyPlowingLabel: UILabel!
  @IBOutlet weak var completedLabel: UILabel!
  @IBOutlet weak var callCustomerLabel: UILabel!
  
  var isEnrouteSelected = false {
    didSet {
      print(isEnrouteSelected)
      if isEnrouteSelected {
        enrouteLabel.makeSelected()
      } else {
        enrouteLabel.makeNotSelected()
      }
    }
  }
  
  var isCurrentlyPlowingSelected = false {
    didSet {
      print(isCurrentlyPlowingSelected)
      if isCurrentlyPlowingSelected {
        currentlyPlowingLabel.makeSelected()
      } else {
        currentlyPlowingLabel.makeNotSelected()
      }
    }
  }
  
  var isCompletedSelected = false {
    didSet {
      print(isCompletedSelected)
      if isCompletedSelected {
        enrouteLabel.makeDisabled()
        currentlyPlowingLabel.makeDisabled()
        completedLabel.makeSelected()
      } else {
        completedLabel.makeNotSelected()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    
    let state = currentTask.state
    
    switch state {
    case .none:
      isEnrouteSelected = false
      isCurrentlyPlowingSelected = false
      isCompletedSelected = false
      break
    case .assigned:
      isEnrouteSelected = false
      isCurrentlyPlowingSelected = false
      isCompletedSelected = false
      break
    case .enroute:
      isEnrouteSelected = true
      isCurrentlyPlowingSelected = false
      isCompletedSelected = false
      break
    case .plowing:
      isEnrouteSelected = false
      isCurrentlyPlowingSelected = true
      isCompletedSelected = false
      enrouteLabel.makeDisabled()
      break
    case .completed:
      isEnrouteSelected = false
      isCurrentlyPlowingSelected = false
      isCompletedSelected = true
      enrouteLabel.makeDisabled()
      currentlyPlowingLabel.makeDisabled()
      break
    }
    
    
    enrouteLabel.layer.cornerRadius = 5.0
    enrouteLabel.layer.masksToBounds = true
    
    currentlyPlowingLabel.layer.cornerRadius = 5.0
    currentlyPlowingLabel.layer.masksToBounds = true
    
    completedLabel.layer.cornerRadius = 5.0
    completedLabel.layer.masksToBounds = true
    
    callCustomerLabel.layer.cornerRadius = 5.0
    callCustomerLabel.layer.masksToBounds = true
    

    
    callCustomerLabel.makeSelected()
  }
  
  func setupUI() {
    let enrouteTapGesture = UITapGestureRecognizer(target: self, action: #selector(enrouteLabelTapped))
    enrouteTapGesture.numberOfTouchesRequired = 1
    enrouteTapGesture.numberOfTapsRequired = 1
    enrouteLabel.isUserInteractionEnabled = true
    enrouteLabel.addGestureRecognizer(enrouteTapGesture)
    
    let currentlPlowingTapGesture = UITapGestureRecognizer(target: self, action: #selector(currentlyPlowingLabelTapped))
    currentlPlowingTapGesture.numberOfTouchesRequired = 1
    currentlPlowingTapGesture.numberOfTapsRequired = 1
    currentlyPlowingLabel.isUserInteractionEnabled = true
    currentlyPlowingLabel.addGestureRecognizer(currentlPlowingTapGesture)
    
    let completedTapGesture = UITapGestureRecognizer(target: self, action: #selector(completedLabelTapped))
    completedTapGesture.numberOfTouchesRequired = 1
    completedTapGesture.numberOfTapsRequired = 1
    completedLabel.isUserInteractionEnabled = true
    completedLabel.addGestureRecognizer(completedTapGesture)
  }
  
  @objc func enrouteLabelTapped() {    
    isEnrouteSelected = !isEnrouteSelected
    isCurrentlyPlowingSelected = false
    isCompletedSelected = false
  }
  
  @objc func currentlyPlowingLabelTapped() {
    isCurrentlyPlowingSelected = !isCurrentlyPlowingSelected
    isEnrouteSelected = false
    isCompletedSelected = false
    
    enrouteLabel.makeDisabled()
  }
  
  @objc  func completedLabelTapped() {
    isCompletedSelected = !isCompletedSelected
    isEnrouteSelected = false
    isCurrentlyPlowingSelected = false
    
    enrouteLabel.makeDisabled()
    currentlyPlowingLabel.makeDisabled()
  }
}




































