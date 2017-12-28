//
//  ForgotPasswordController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/27/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordController: UIViewController {
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBOutlet weak var retrievePasswordLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(retrievePasswordTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
       retrievePasswordLabel.isUserInteractionEnabled = true
      retrievePasswordLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    retrievePasswordLabel.layer.cornerRadius = 5.0
    retrievePasswordLabel.layer.masksToBounds = true
  }
  
  @objc func retrievePasswordTapped() {
    let email = emailAddressTextField.text ?? ""
    
    SVProgressHUD.show()
    User.resetPassword(email: email) { (error) in
      if let error = error {
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
          self.showErrorAlert(message: error.localizedDescription)
        }
      } else {
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
          self.showErrorAlert(message: "A reset link was sent.", okTapped: {
            self.dismiss(animated: true)
          })
        }
      }
    }
  }
  
  @IBAction func closeButtonTapped() {
    dismiss(animated: true)
  }
}

























