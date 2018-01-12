//
//  SupportChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 1/11/18.
//  Copyright © 2018 plowdr. All rights reserved.
//

import UIKit

class SupportChildController: UITableViewController {
  
  @IBOutlet weak var callButton: UIButton!
  @IBOutlet weak var emailButton: UIButton!
  
  @IBOutlet weak var termsConditionsButton: UIButton!
  @IBOutlet weak var privacyPolicyButton: UIButton!
  
  @IBOutlet weak var contractsButton: UIButton!
  @IBOutlet weak var coverageButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    callButton.layer.cornerRadius = 5.0
    callButton.layer.masksToBounds = true
    
    emailButton.layer.cornerRadius = 5.0
    emailButton.layer.masksToBounds = true
    
    termsConditionsButton.layer.cornerRadius = 5.0
    termsConditionsButton.layer.masksToBounds = true
    
    privacyPolicyButton.layer.cornerRadius = 5.0
    privacyPolicyButton.layer.masksToBounds = true
    
    contractsButton.layer.cornerRadius = 5.0
    contractsButton.layer.masksToBounds = true
    
    coverageButton.layer.cornerRadius = 5.0
    coverageButton.layer.masksToBounds = true
  }
  
  
  @IBAction func callButtonTapped(_ sender: Any) {
  }
  
  @IBAction func emailButtonTapped(_ sender: Any) {
  }
  
  @IBAction func termsConditionsButtonTapped(_ sender: Any) {
  }
  
  @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
  }
  
  @IBAction func contractsButtonTapped(_ sender: Any) {
  }
  
  @IBAction func coverageAreasButtonTapped(_ sender: Any) {
  }
  

}






















