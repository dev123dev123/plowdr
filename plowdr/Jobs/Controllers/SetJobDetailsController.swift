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

class SetJobDetailsController: UIViewController {
  
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
    
    guard let currentUserId = User.currentUser?.id else {
      showErrorAlert(message: "User id not found, please log in again.")
      return
    }
    DispatchQueue.main.async {
      SVProgressHUD.show(withStatus: "Loading")
    }
    print("progress showed")
    
    Job.save(
      userId: currentUserId,
      jobType: jobType,
      address: address,
      dateSelected: dateSelected,
      bestTime: bestTime,
      jobDetail: jobDetail) { (error) in
        print("progress hidden")
        
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
        }
        
        if let error = error {
          self.showErrorAlert(message: error.localizedDescription)
        } else {
          self.navigationController?.backTo(type: HomeController.self)
        }
    }
    
//    performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToSetPayment, sender: nil)
    //    performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToPurchaseService, sender: nil)
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
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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








































