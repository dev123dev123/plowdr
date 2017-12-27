//
//  InvoiceDetailChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class InvoiceDetailChildController: UITableViewController {
  var currentTask: Task!
  var numberFormatter = NumberFormatter()
  
  @IBOutlet weak var jobTypeLabel: UILabel!
  @IBOutlet weak var drivewayLabel: UILabel!
  @IBOutlet weak var detailsLabel: UILabel!
  
  @IBOutlet weak var paymentLabel: UILabel!
  @IBOutlet weak var creditCardLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.currencyCode = "USD"
    
    jobTypeLabel.text = "\(currentTask.jobType.rawValue) Plow"
    drivewayLabel.text = "\(currentTask.howDeepSnow)"
    detailsLabel.text = "\(currentTask.howLong) by \(currentTask.howWide)"
    paymentLabel.text = "\( numberFormatter.string(from: NSNumber(value: currentTask.payment / 100))! )"
    creditCardLabel.text = "\(User.currentUser?.activeCardDescription ?? "")"
  }
}










































