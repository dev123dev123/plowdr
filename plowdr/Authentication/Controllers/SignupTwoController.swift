//
//  SignupTwoController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupTwoController: UIViewController {
  var childController: SignupTwoChildController?
  var delegate: SignupOneDelegate?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.SignupTwoChild {
      let destinationVC = segue.destination as? SignupTwoChildController
      childController = destinationVC
    }
  }
  
  @IBOutlet weak var signupLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signupLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      signupLabel.isUserInteractionEnabled = true
      signupLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func signupLabelTapped() {
    guard let delegate = delegate else {
      // show appropiate error message
      return
    }
    
    guard let childController = childController else {
      // show appropiate error message
      return
    }
    
    let email = delegate.email
    let mobile = delegate.mobile
    let password = delegate.password
    let firstName = childController.firstNameTextField.text!
    let lastName = childController.lastNameTextField.text!
    
    SVProgressHUD.show()
    signupLabel.isUserInteractionEnabled = false
    signupLabel.alpha = 0.5
    User.signUp(
      email: email,
      mobile: mobile,
      password: password,
      firstName: firstName,
      lastName: lastName) { (newUser, error) in
        User.currentUser = newUser
        
        DispatchQueue.main.async {
          self.signupLabel.isUserInteractionEnabled = true
          self.signupLabel.alpha = 1
          SVProgressHUD.dismiss()
        }
        
        if let _ = newUser {
          DispatchQueue.main.async {
            self.performSegue(withIdentifier: StoryboardSegues.SignupTwoToHome, sender: nil)
          }
        } else if let error = error {
          DispatchQueue.main.async {
            self.showErrorAlert(message: error.localizedDescription)
          }
        } else {
          DispatchQueue.main.async {
            self.showErrorAlert(message: Strings.ErrorMessages.genericMessage)
          }
        }
    }
  }
  
}































