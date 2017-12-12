//
//  UpdateServiceChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class UpdateServiceChildController: UITableViewController {
  
  @IBOutlet weak var enrouteLabel: UILabel!
  @IBOutlet weak var currentlyPlowingLabel: UILabel!
  @IBOutlet weak var completedLabel: UILabel!
  @IBOutlet weak var callCustomerLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    setupUI()
    
    enrouteLabel.layer.cornerRadius = 5.0
    enrouteLabel.layer.masksToBounds = true
    
    currentlyPlowingLabel.layer.cornerRadius = 5.0
    currentlyPlowingLabel.layer.masksToBounds = true
    
    completedLabel.layer.cornerRadius = 5.0
    completedLabel.layer.masksToBounds = true
    
    callCustomerLabel.layer.cornerRadius = 5.0
    callCustomerLabel.layer.masksToBounds = true
    
    enrouteLabel.makeNotSelected()
    currentlyPlowingLabel.makeNotSelected()
    completedLabel.makeNotSelected()
    
    callCustomerLabel.makeSelected()
  }
}
