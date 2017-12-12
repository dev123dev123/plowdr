//
//  JobDetailChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/1/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class JobDetailChildController: UITableViewController {
  
  @IBOutlet weak var titleJobLabel: UILabel!
  @IBOutlet weak var subtitleJobLabel: UILabel!
  
  @IBOutlet weak var driverInfoLabel: UILabel!
  @IBOutlet weak var vehicleInfoTextView: UITextView!
  
  @IBOutlet weak var callDriverLabel: UILabel!
  @IBOutlet weak var viewInvoiceLabel: UILabel!
  
  @IBOutlet weak var borderView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    
    borderView.layer.borderColor = UIColor.white.cgColor
    borderView.layer.borderWidth = 5
  }
  
  func setupViews() {
    callDriverLabel.layer.cornerRadius = 5.0
    callDriverLabel.layer.masksToBounds = true
    viewInvoiceLabel.layer.cornerRadius = 5.0
    viewInvoiceLabel.layer.masksToBounds = true
    
    let callDriverTapGesture = UITapGestureRecognizer(target: self, action: #selector(callDriverLabelTapped))
    callDriverTapGesture.numberOfTapsRequired = 1
    callDriverTapGesture.numberOfTouchesRequired = 1
    callDriverLabel.isUserInteractionEnabled = true
    callDriverLabel.addGestureRecognizer(callDriverTapGesture)
    
    let viewInvoiceTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewInvoiceLabelTapped))
    viewInvoiceTapGesture.numberOfTapsRequired = 1
    viewInvoiceTapGesture.numberOfTouchesRequired = 1
    
    viewInvoiceLabel.isUserInteractionEnabled = true
    viewInvoiceLabel.addGestureRecognizer(viewInvoiceTapGesture)
    
  }
  
  @objc func callDriverLabelTapped() {
    makePhoneCall()
  }
  
  @objc func viewInvoiceLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.JobDetailChildToInvoiceDetail, sender: nil)
  }
  
  func makePhoneCall() {
    let number = "+5917074456"
    let application = UIApplication.shared
    
    if let phoneCallURL = URL(string: "tel:\(number)") {
      if application.canOpenURL(phoneCallURL) {
        application.open(phoneCallURL, options: [:], completionHandler: { (finished) in
          print(finished)
        })
      }
    }
    
  }

}








































