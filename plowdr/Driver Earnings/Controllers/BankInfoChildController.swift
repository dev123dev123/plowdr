//
//  BankInfoChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class BankInfoChildController: UITableViewController {
  
  @IBOutlet weak var bankNameTextField: UITextField!
  @IBOutlet weak var accountNumberTextField: UITextField!
  @IBOutlet weak var routingNumberTextField: UITextField!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bankNameTextField.text = User.currentUser?.bankName
    accountNumberTextField.text = User.currentUser?.accountNumber
    routingNumberTextField.text = User.currentUser?.routingNumber
  }
}
