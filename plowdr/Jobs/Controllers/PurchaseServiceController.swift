//
//  PurchaseServiceController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/22/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol PurchaseServiceDelegate {
  func editButtonTapped()
}

class PurchaseServiceController: UIViewController {
  
  @IBOutlet weak var purchaseServiceLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(purchaseServiceLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      purchaseServiceLabel.isUserInteractionEnabled = true
      purchaseServiceLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  
  @objc func purchaseServiceLabelTapped() {
    navigationController?.backTo(type: HomeController.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.PurchaseServiceChild {
      let destinationVC = segue.destination as? PurchaseServiceChildController
      destinationVC?.delegate = self
    }
  }
}

extension PurchaseServiceController: PurchaseServiceDelegate {
  
  func editButtonTapped() {
    performSegue(withIdentifier: StoryboardSegues.PurchaseServiceToSetPayment, sender: nil)
  }
  
}
