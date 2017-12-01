//
//  SetAccountChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/27/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class SetAccountChildController: UITableViewController {
  var setAccountType: SetAccountType?
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var mobileTextField: UITextField!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var vehicleInfoLabel: UILabel!
  
  @IBOutlet weak var resetLabel: UILabel! {
    didSet {
//      let tapGesture = UITapGestureRecognizer(target: self, action: #selector())
    }
  }
  
  @IBOutlet weak var vehicleCell: UITableViewCell!
}

extension SetAccountChildController {
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if cell === vehicleCell {
      if setAccountType == .client {
        return 0
      }
    }
    
    return super.tableView(tableView, heightForRowAt: indexPath)
  }
  
}
