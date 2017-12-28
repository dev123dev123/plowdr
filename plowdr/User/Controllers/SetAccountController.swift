//
//  SetAccountController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/27/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

enum SetAccountType {
  case driver
  case client
}

class SetAccountController: UIViewController {
  
  var childController: SetAccountChildController?
  var setAccountType: SetAccountType?
  
  @IBOutlet weak var updateLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateButtonTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      updateLabel.isUserInteractionEnabled = true
      updateLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.SetAccountChild {
      let destinationVC = segue.destination as? SetAccountChildController
      destinationVC?.setAccountType = setAccountType
      childController = destinationVC
    }
  }
  
  @IBAction func closeButtonTapped() {
    dismiss(animated: true)
  }
  
  @objc func updateButtonTapped() {
    let firstName = childController?.firstNameTextField.text ?? ""
    let lastName = childController?.lastNameTextField.text ?? ""
    let mobile = childController?.mobileTextField.text ?? ""
  
    SVProgressHUD.show()
    User.update(
      byUserId: User.currentUser?.id,
      withFirstName: firstName,
      andLastName: lastName,
      andMobile: mobile) { (error) in
        if let error = error {
          DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showErrorAlert(message: error.localizedDescription)
          }
        } else {
          User.currentUser?.firstName = firstName
          User.currentUser?.lastName = lastName
          User.currentUser?.mobile = mobile
          
          DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showErrorAlert(message: Strings.UI.updatedUserInfoSuccessfully, okTapped: {
              DispatchQueue.main.async {
                self.dismiss(animated: true)
              }
            })
          }
        }
    }
  }
  
}















































