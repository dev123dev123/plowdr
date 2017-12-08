//
//  PurchaseServiceController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/22/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol PurchaseServiceDelegate {
  func editButtonTapped()
}

class PurchaseServiceController: UIViewController {
  
  var paymentContextImplementation: STPPaymentContextImplementation?
  var parameters: [String: Any]?
  var childViewController: PurchaseServiceChildController?
  
  var currenUserId: String!
  var jobType: JobType!
  var address: Address!
  var dateSelected: (String, Date)!
  var bestTime: BestTime!
  var jobDetail: JobDetail!
  
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
    SVProgressHUD.show()
    paymentContextImplementation?.requestPayment()
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
    
    guard let currentUserId = User.currentUser?.id else {
      self.showErrorAlert(message: "Current user id value not found.")
      return
    }
    
    guard let jobType = parameters?["jobType"] as? JobType else {
      self.showErrorAlert(message: "Job type value not found.")
      return
    }
    
    guard let address = parameters?["address"] as? Address else {
      self.showErrorAlert(message: "Address value not found.")
      return
    }
    
    guard let dateSelected = parameters?["dateSelected"] as? (String, Date) else {
      self.showErrorAlert(message: "Date selected value not found.")
      return
    }
    
    guard let bestTime = parameters?["bestTime"] as? BestTime else {
      self.showErrorAlert(message: "Best time value not found.")
      return
    }
    
    guard let jobDetail = parameters?["jobDetail"] as? JobDetail else {
      self.showErrorAlert(message: "Job detail value not found.")
      return
    }
    
    self.currenUserId = currentUserId
    self.jobType = jobType
    self.address = address
    self.dateSelected = dateSelected
    self.bestTime = bestTime
    self.jobDetail = jobDetail
    
    switch jobType {
    case .monthly:
      paymentContextImplementation?.paymentAmount = Strings.Prices.monthlyPrice
      break
    case .single:
      paymentContextImplementation?.paymentAmount = Strings.Prices.singlePrice
      break
    case .unlimited:
      paymentContextImplementation?.paymentAmount = Strings.Prices.unlimitedPrice
      break
    }

  }
}

extension PurchaseServiceController: PurchaseServiceDelegate {
  
  func editButtonTapped() {
    paymentContextImplementation?.showPaymentFormOnHostViewController()
  }
  
}

extension PurchaseServiceController: PaymentContextDelegate {
  func chargeResult(error: Error?) {
    
    if let error = error {
      DispatchQueue.main.async {
        SVProgressHUD.dismiss()
        self.showErrorAlert(message: error.localizedDescription)
      }
    } else {
      Job.save(
        userId: currenUserId,
        jobType: jobType,
        address: address,
        dateSelected: dateSelected,
        bestTime: bestTime,
        jobDetail: jobDetail) { (error) in
          DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            
            if let error = error {
              self.showErrorAlert(message: error.localizedDescription)
            } else {
              self.navigationController?.backTo(type: HomeController.self)
            }
          }
      }
    }
    
  }
  
  func paymentSelectionResult(_ wasSetPayment: Bool, cardDescription: String, error: Error?) {
    
    if let error = error {
      DispatchQueue.main.async {
        self.showErrorAlert(message: error.localizedDescription)
      }
      
      return
    }
    
    childViewController?.activeCardDescriptionChanged(newValue: cardDescription)
    
  }
  
  
}





























