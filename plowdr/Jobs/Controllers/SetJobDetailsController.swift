//
//  SetJobDetailsController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/16/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SetJobDetailsDelegate {
  func addressSelected()
  func dateTimeSelected()
  func jobDetailSelected()
  func paymentSet()
}

protocol JobDetailsDelegate {
  func addressSent(_ address: Address)
  func dateTimeSent(_ date: (String, Date), bestTime: BestTime)
  func jobDetailSent(_ jobDetail: JobDetail)
}

protocol PaymentContextDelegate {
  func paymentSelectionResult(_ wasSetPayment: Bool, cardDescription: String, error: Error?)
  func chargeResult(error: Error?, chargeIdCreated: String?)
}

class SetJobDetailsController: BaseViewController {
  var paymentContextImplementation: STPPaymentContextImplementation?
  
  var jobType: JobType?
  var address: Address?
  var dateSelected: (String, Date)?
  var bestTime: BestTime?
  var jobDetail: JobDetail?
  
  @IBOutlet weak var paymentEstimateLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(paymentLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      paymentEstimateLabel.isUserInteractionEnabled = true
      
      paymentEstimateLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func paymentLabelTapped() {
    guard let jobType = jobType else {
      showErrorAlert(message: "Please set job type.")
      return
    }
    guard let address = address else {
      showErrorAlert(message: "Please set address.")
      return
    }

    guard
      let dateSelected = dateSelected,
      let bestTime = bestTime
    else {
      showErrorAlert(message: "Please set date.")
      return
    }

    guard let jobDetail = jobDetail else {
      showErrorAlert(message: "Please set job details.")
      return
    }

    guard let _ = User.currentUser?.id else {
      showErrorAlert(message: "User id not found, please log in again.")
      return
    }
    

    print("progress showed")
    
    if let activeCardDescription = User.currentUser?.activeCardDescription {
      var values = [String: Any]()
      values["activeCardDescription"] = activeCardDescription
      values["jobType"] = jobType
      values["address"] = address
      values["dateSelected"] = dateSelected
      values["bestTime"] = bestTime
      values["jobDetail"] = jobDetail
      
      performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToPurchaseService, sender: values)
    } else {
      paymentContextImplementation?.showPaymentFormOnHostViewController()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.SetJobDetailsChild {
      let destinationVC = segue.destination as? SetJobDetailsChildController
      destinationVC?.delegate = self
      destinationVC?.jobType = jobType
    } else if segue.identifier == StoryboardSegues.SetJobDetailsToSetAddress {
      let destinationVC = segue.destination as? SetAddressController
      destinationVC?.delegate = self
      destinationVC?.addressSelected = address
    } else if segue.identifier == StoryboardSegues.SetJobDetailsToSetDateTime {
      let destinationVC = segue.destination as? SetDateTimeController
      destinationVC?.delegate = self
      destinationVC?.bestTimeSelected = bestTime ?? .morning
      destinationVC?.dateSelected = dateSelected
    } else if segue.identifier == StoryboardSegues.SetJobDetailsToSetJobDetail {
      let destinationVC = segue.destination as? SetJobDetailController
      destinationVC?.delegate = self
      destinationVC?.jobDetail = jobDetail
    } else if segue.identifier == StoryboardSegues.SetJobDetailsToSetPayment {
      let destinationVC = segue.destination as? SetPaymentController
      destinationVC?.delegate = self
    } else if segue.identifier == StoryboardSegues.SetJobDetailsToPurchaseService {
      let destinationVC = segue.destination as? PurchaseServiceController
      destinationVC?.parameters = sender as? [String: Any]
    } else if segue.identifier == StoryboardSegues.SetJobDetailsToJobDescription {
      let destinationVC = segue.destination as? JobDescriptionController
      destinationVC?.jobType = jobType
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let infoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    infoButton.setImage(UIImage(named: "info-button"), for: .normal)
    infoButton.imageView?.contentMode = .scaleAspectFit
    infoButton.contentMode = .center
    infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    
    let showInfo = UIBarButtonItem(customView: infoButton)
    navigationItem.rightBarButtonItem = showInfo
    
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    titleLabel.font = UIFont(name: "AGStencil", size: 35)
    titleLabel.textColor = UIColor.white
    titleLabel.textAlignment = .center
    titleLabel.text = "plowdr"
    titleLabel.textColor = UIColor.init(red: 113.0/255.0, green: 168.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    navigationItem.titleView = titleLabel
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 32))
    button.setImage(UIImage(named: "back-button"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    
    let showMenu = UIBarButtonItem(customView: button)
    navigationItem.leftBarButtonItem = showMenu
    
    paymentContextImplementation = STPPaymentContextImplementation()
    paymentContextImplementation?.hostViewController = self
  }
  
  @objc func infoButtonTapped() {
    performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToJobDescription, sender: nil)
  }
  
  @objc func backButtonTapped() {
    self.navigationController?.popViewController(animated: true)
  }
}


extension SetJobDetailsController: SetJobDetailsDelegate {
  func paymentSet() {
    performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToPurchaseService, sender: nil)
  }
  
  func addressSelected() {
    performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToSetAddress, sender: nil)
  }
  
  func dateTimeSelected() {
    performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToSetDateTime, sender: nil)
  }
  
  func jobDetailSelected() {
    performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToSetJobDetail, sender: nil)
  }
}

extension SetJobDetailsController: JobDetailsDelegate {
  func dateTimeSent(_ date: (String, Date), bestTime: BestTime) {
    self.dateSelected = date
    self.bestTime = bestTime
  }
  
  func addressSent(_ address: Address) {
    self.address = address
  }
  
  func jobDetailSent(_ jobDetail: JobDetail) {
    self.jobDetail = jobDetail
  }
}

//extension SetJobDetailsController: PaymentContextDelegate {
//  func chargeResult(error: Error?) {
//  }
//
//  func paymentSelectionResult(_ wasSetPayment: Bool, cardDescription: String, error: Error?) {
//  }
//}










































