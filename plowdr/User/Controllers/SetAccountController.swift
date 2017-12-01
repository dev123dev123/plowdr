//
//  SetAccountController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/27/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

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
    guard let firstName = childController?.firstNameTextField.text else {
      
      return
    }
    
    guard let lastName = childController?.lastNameTextField.text else {
      
      return
    }
    
    guard let mobile = childController?.mobileTextField.text else {
      
      return
    }
    
    print(firstName)
    print(lastName)
    print(mobile)
    
    dismiss(animated: true)
  }
  
}















































