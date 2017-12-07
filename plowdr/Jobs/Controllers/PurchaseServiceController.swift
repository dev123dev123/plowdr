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
  
  var paymentContextImplementation: STPPaymentContextImplementation?
  var parameters: [String: Any]?
  var childViewController: PurchaseServiceChildController?
  
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
    
    // 2. already has a card
    //    DispatchQueue.main.async {
    //      SVProgressHUD.show(withStatus: "Loading")
    //    }
    //    Job.save(
    //      userId: currentUserId,
    //      jobType: jobType,
    //      address: address,
    //      dateSelected: dateSelected,
    //      bestTime: bestTime,
    //      jobDetail: jobDetail) { (error) in
    //        print("progress hidden")
    //
    //        DispatchQueue.main.async {
    //          SVProgressHUD.dismiss()
    //        }
    //
    //        if let error = error {
    //          self.showErrorAlert(message: error.localizedDescription)
    //        } else {
    //          self.navigationController?.backTo(type: HomeController.self)
    //        }
    //    }
    
    
    navigationController?.backTo(type: HomeController.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.PurchaseServiceChild {
      let destinationVC = segue.destination as? PurchaseServiceChildController
      destinationVC?.delegate = self
      destinationVC?.parameters = parameters
      childViewController = destinationVC
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    paymentContextImplementation = STPPaymentContextImplementation()
    paymentContextImplementation?.hostViewController = self
    paymentContextImplementation?.delegate = self
  }
}

extension PurchaseServiceController: PurchaseServiceDelegate {
  
  func editButtonTapped() {
    paymentContextImplementation?.showPaymentFormOnHostViewController()
  }
  
}

extension PurchaseServiceController: PaymentContextDelegate {
  func paymentResultSent(_ wasSetPayment: Bool, cardDescription: String, error: Error?) {
    
    if let error = error {
      DispatchQueue.main.async {
        self.showErrorAlert(message: error.localizedDescription)
      }
      
      return
    }
    
    childViewController?.activeCardDescriptionChanged(newValue: cardDescription)
  }
}





























