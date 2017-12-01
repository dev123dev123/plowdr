//
//  SignupOneChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/28/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class SignupOneChildController: UITableViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var mobileTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailTextField.delegate = self
    mobileTextField.delegate = self
    passwordTextField.delegate = self
    
    let (doneButton, toolBarButton)  = createDoneButtonOnKeyboard()
    mobileTextField.inputAccessoryView = toolBarButton
    
    doneButton.target = self
    doneButton.action = #selector(dismissKeyboard)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension SignupOneChildController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
