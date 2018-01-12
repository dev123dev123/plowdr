//
//  EarningsChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol EarningsDelegate {
  func didPayStubsTap()
  func didBankInfoTap()
}

class EarningsChildController: UITableViewController {
  var delegate: EarningsDelegate?
  var isCurrentEarnings = true
  
  var formatter = NumberFormatter()
  
  var currentGroupedTask: [String: Any]?
  
  @IBOutlet weak var dateFromToLabel: UILabel!
  @IBOutlet weak var paymentLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    payStubsLabel.layer.cornerRadius = 5.0
    payStubsLabel.layer.masksToBounds = true
    
    bankInfoLabel.layer.cornerRadius = 5.0
    bankInfoLabel.layer.masksToBounds = true
    
    if isCurrentEarnings {
      payStubsLabel.isHidden = false
      bankInfoLabel.isHidden = false
    } else {
      payStubsLabel.isHidden = true
      bankInfoLabel.isHidden = true
    }
  }
  
  func setUIValues(groupedTask: [String: Any]) {
    setDateFromToTitle(text: groupedTask["id"] as? String)
    setPayment(totalPayment: groupedTask["totalPayment"] as! Int / 100)
  }
  
  func setDateFromToTitle(text: String?) {
    dateFromToLabel.text = text
  }
  
  func setPayment(totalPayment: Int) {
    let payment = NSNumber(value: totalPayment / 100)
    
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    
    paymentLabel.text = formatter.string(from: payment)
  }
  
  @IBOutlet weak var payStubsLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(payStubsLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      payStubsLabel.isUserInteractionEnabled = true
      payStubsLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var bankInfoLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bankInfoLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      bankInfoLabel.isUserInteractionEnabled = true
      bankInfoLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func bankInfoLabelTapped() {
    delegate?.didBankInfoTap()
  }
  
  @objc func payStubsLabelTapped() {
    delegate?.didPayStubsTap()
  }
}























