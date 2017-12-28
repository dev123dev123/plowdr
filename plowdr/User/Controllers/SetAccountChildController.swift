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
  @IBOutlet weak var vehicleInfoTextView: UITextView!
  
  @IBOutlet weak var resetLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
     resetLabel.isUserInteractionEnabled = true
      resetLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var requestChangeLabel: UIButton! {
    didSet{
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(requestChangeLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      requestChangeLabel.isUserInteractionEnabled = true
      requestChangeLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  
  @IBOutlet weak var vehicleCell: UITableViewCell!
  
  @objc func requestChangeLabelTapped() {
    print("request change label tapped")
  }
  
  @objc func resetLabelTapped() {
    print("reset label tapped")
    performSegue(withIdentifier: StoryboardSegues.SetAccountToResetPassword, sender: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    resetLabel.layer.cornerRadius = 5.0
    resetLabel.layer.masksToBounds = true
    
    requestChangeLabel.layer.cornerRadius = 5.0
    requestChangeLabel.layer.masksToBounds = true
    
    if let currentUser = User.currentUser {
      firstNameTextField.text = currentUser.firstName
      lastNameTextField.text = currentUser.lastName
      mobileTextField.text = currentUser.mobile
      emailLabel.text = currentUser.email
      vehicleInfoTextView.text = currentUser.vehicleInfo
      
      if currentUser.role == UserRole.driver.rawValue {
        setAccountType = .driver
      } else {
        setAccountType = .client
      }
    } else {
      showErrorAlert(message: "Please log in again.")
    }
  }
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



















