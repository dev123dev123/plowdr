//
//  LoginController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginController: UIViewController {
  @IBOutlet weak var loginLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      loginLabel.isUserInteractionEnabled = true
      loginLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  
  @objc func loginLabelTapped() {
    let email = emailTextField.text!
    let password = passwordTextField.text!
    
    SVProgressHUD.show()
    User.login(
      email: email,
      password: password) { (user, error) in
        User.currentUser = user
        
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
        }
        
        if let error = error {
          DispatchQueue.main.async {
            self.showErrorAlert(message: error.localizedDescription)
          }
        } else if let _ = user {
          DispatchQueue.main.async {
            self.performSegue(withIdentifier: StoryboardSegues.LoginToHome, sender: nil)
          }
        } else {
          
        }
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}

extension LoginController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    return true
  }
  
}























