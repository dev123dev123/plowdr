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
  func didPriceGet(isCustomPrice: Bool)
}

class PurchaseServiceController: BaseViewController {
  
  var paymentContextImplementation: STPPaymentContextImplementation?
  var parameters: [String: Any]?
  var childViewController: PurchaseServiceChildController?
  
  var currenUserId: String!
  var jobType: JobType!
  var address: Address!
  var dateSelected: (String, Date)!
  var bestTime: BestTime!
  var jobDetail: JobDetail!
  var isCustomPrice = false
  
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
    purchaseServiceLabel.isUserInteractionEnabled = false
    purchaseServiceLabel.alpha = 0.5
    
    if !isCustomPrice {
      paymentContextImplementation?.requestPayment()
    } else {
      Job.save(
        userId: currenUserId,
        clientName: "\(User.currentUser!.firstName ) \(User.currentUser!.lastName)",
        jobType: jobType,
        address: address,
        dateSelected: dateSelected,
        bestTime: bestTime,
        jobDetail: jobDetail,
        chargeId: "#not charged yet, custom price",
        payment: 0,
        isCustomPrice: isCustomPrice
      ) { (error) in
        DispatchQueue.main.async {
          self.purchaseServiceLabel.isUserInteractionEnabled = true
          self.purchaseServiceLabel.alpha = 1
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
    
    purchaseServiceLabel.alpha = 0.5
    purchaseServiceLabel.isUserInteractionEnabled = false
    
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
    case .single:
      paymentContextImplementation?.paymentAmount = Strings.Prices.singlePrice
      paymentContextImplementation?.paymentWillBeChargedImmediately = false
    case .unlimited:
      paymentContextImplementation?.paymentAmount = Strings.Prices.unlimitedPrice
    }

  }
}

extension PurchaseServiceController: PurchaseServiceDelegate {
  func didPriceGet(isCustomPrice: Bool) {
    self.isCustomPrice = isCustomPrice
    DispatchQueue.main.async {
      self.purchaseServiceLabel.isUserInteractionEnabled = true
      self.purchaseServiceLabel.alpha = 1
    }
  }
  
  
  func editButtonTapped() {
    paymentContextImplementation?.showPaymentFormOnHostViewController()
  }
  
}

extension PurchaseServiceController: PaymentContextDelegate {
  func chargeResult(error: Error?, chargeIdCreated: String?) {
    
    if let error = error {
      purchaseServiceLabel.isUserInteractionEnabled = true
      purchaseServiceLabel.alpha = 1
      
      DispatchQueue.main.async {
        SVProgressHUD.dismiss()
        self.showErrorAlert(message: error.localizedDescription)
      }
    } else {
      guard let chargeId = chargeIdCreated else {
        purchaseServiceLabel.isUserInteractionEnabled = true
        purchaseServiceLabel.alpha = 1
        
        self.showErrorAlert(message: "Charge Id wasn't provided.")
        return
      }
      
      Job.save(
        userId: currenUserId,
        clientName: "\(User.currentUser!.firstName ) \(User.currentUser!.lastName)",
        jobType: jobType,
        address: address,
        dateSelected: dateSelected,
        bestTime: bestTime,
        jobDetail: jobDetail,
        chargeId: chargeId,
        payment: paymentContextImplementation?.paymentAmount ?? 0,
        isCustomPrice: isCustomPrice
      ) { (error) in
          DispatchQueue.main.async {
            self.purchaseServiceLabel.isUserInteractionEnabled = true
            self.purchaseServiceLabel.alpha = 1
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





























