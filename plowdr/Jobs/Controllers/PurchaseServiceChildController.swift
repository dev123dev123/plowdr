//
//  PurchaseServiceChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/27/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class PurchaseServiceChildController: UITableViewController {
  var delegate: PurchaseServiceDelegate?
  var parameters: [String: Any]?
  
  var paymentAmount: Int = 0
  
  @IBOutlet weak var jobTypeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var bestTimeLabel: UILabel!
  @IBOutlet weak var howWideLabel: UILabel!
  @IBOutlet weak var howLongLabel: UILabel!
  @IBOutlet weak var howDeepLabel: UILabel!
  @IBOutlet weak var obstaclesTextView: UITextView!
  
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var cardLabel: UILabel!
  
  var activeCardDescription: String!
  var jobType: JobType!
  var address: Address!
  var dateSelected: (String, Date)!
  var bestTime: BestTime!
  var jobDetail: JobDetail!
  
  var formatter = NumberFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let parameters = parameters else {
      self.showErrorAlert(message: "Data collected from other screens didn't get here.")
      return
    }
    
    guard let activeCardDescription = parameters["activeCardDescription"] as? String else {
      return
    }
    
    guard let jobType = parameters["jobType"] as? JobType else {
      return
    }
    
    guard let address = parameters["address"] as? Address else {
      return
    }
    
    guard let dateSelected = parameters["dateSelected"] as? (String, Date) else {
      return
    }
    
    guard let bestTime = parameters["bestTime"] as? BestTime else {
      return
    }
    
    guard let jobDetail = parameters["jobDetail"] as? JobDetail else {
      return
    }
    
    switch jobType {
    case .monthly:
      paymentAmount = Strings.Prices.monthlyPrice
    case .single:
      paymentAmount = Strings.Prices.singlePrice
    case .unlimited:
      paymentAmount = Strings.Prices.unlimitedPrice
    }

    
    let convertPrice = NSNumber(value: (paymentAmount / 100))
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    priceLabel.text = formatter.string(from: convertPrice)
    
    jobTypeLabel.text = jobType.rawValue
    addressLabel.text = address.addressLine
    dateLabel.text = dateSelected.0
    bestTimeLabel.text = bestTime.rawValue
    howWideLabel.text = jobDetail.howWide
    howLongLabel.text = jobDetail.howLong
    howDeepLabel.text = jobDetail.howDeepSnow
    obstaclesTextView.text = jobDetail.obstacles
    
    cardLabel.text = activeCardDescription
  }
  
  func activeCardDescriptionChanged(newValue: String) {
    DispatchQueue.main.async {
      self.cardLabel.text = newValue
    }
  }
  
  @IBOutlet weak var editPaymentLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editPaymentLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      editPaymentLabel.isUserInteractionEnabled = true
      editPaymentLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func editPaymentLabelTapped() {
    delegate?.editButtonTapped()
  }
}
