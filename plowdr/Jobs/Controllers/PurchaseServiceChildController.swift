//
//  PurchaseServiceChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/27/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class PurchaseServiceChildController: UITableViewController {
  var delegate: PurchaseServiceDelegate?
  
  @IBAction func editPaymentButtonTapped() {
    delegate?.editButtonTapped()
  }
}
