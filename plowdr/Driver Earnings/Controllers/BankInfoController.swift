//
//  BanknfoController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class BankInfoController: BaseViewController {
  
  var childController: BankInfoChildController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.BankInfoChild {
      let destinationVC = segue.destination as? BankInfoChildController
      childController = destinationVC
    }
  }
  
  @IBOutlet weak var updateLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
            updateLabel.isUserInteractionEnabled = true
      updateLabel.addGestureRecognizer(tapGesture)      
    }
  }
  
  @objc func updateLabelTapped() {
    let bankName = childController?.bankNameTextField.text ?? ""
    let accountNumber = childController?.accountNumberTextField.text ?? ""
    let routingNumber = childController?.routingNumberTextField.text ?? ""
    
    guard let driverId = User.currentUser?.id else {
      showErrorAlert(message: "Driver id is missing, login again please.")
      return
    }
    
    SVProgressHUD.show()
    User.updateDriverBankInfo(
      driverId: driverId,
      bankName: bankName,
      accountNumber: accountNumber,
      routingNumber: routingNumber) { (error) in
        
        if let error = error {
          DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showErrorAlert(message: error.localizedDescription)
          }
        } else {
          DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showErrorAlert(message: "Drive Info was updated succesfully", okTapped: {
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








































