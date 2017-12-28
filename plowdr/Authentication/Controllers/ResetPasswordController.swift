//
//  ResetPasswordController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/27/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResetPasswordController: UIViewController {
  var childController: ResetPasswordChildController?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.ResetPasswordChild {
      let destinationVC = segue.destination as? ResetPasswordChildController
      childController = destinationVC
    }
  }
  
  @IBOutlet weak var resetPasswordLabel: UILabel! {
    didSet{
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetPasswordLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      resetPasswordLabel.isUserInteractionEnabled = true
      resetPasswordLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func resetPasswordLabelTapped() {
    let oldPassword = childController?.oldPasswordTextField.text ?? ""
    let newPassword = childController?.newPasswordTextField.text ?? ""
    let retypePassword = childController?.reTypePasswordextField.text ?? ""
    
    SVProgressHUD.show()
    User.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      repeatedNewPassword: retypePassword) { (error) in
        if let error = error {
          DispatchQueue.main.async {
             SVProgressHUD.dismiss()
            self.showErrorAlert(message: error.localizedDescription)
          }
        } else {
          DispatchQueue.main.async {
             SVProgressHUD.dismiss()
            self.showErrorAlert(message: "Password changed succcesfully", okTapped: {
              self.dismiss(animated: true)
            })
          }
        }
    }
  }
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
  
}




























































