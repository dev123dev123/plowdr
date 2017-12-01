//
//  SignupTwoChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/28/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class SignupTwoChildController: UITableViewController {
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstNameTextField.delegate = self
    lastNameTextField.delegate = self
  }
}

extension SignupTwoChildController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
