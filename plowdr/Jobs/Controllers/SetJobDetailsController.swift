//
//  SetJobDetailsController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/16/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol SetJobDetailsDelegate {
  func addressSelected()
  func dateTimeSelected()
  func jobDetailSelected()
  func paymentSet()
}

protocol JobDetailsDelegate {
  func addressSent(_ address: Address)
  func dateTimeSent(_ schedule: Schedule)
  func jobDetailSent(_ jobDetail: JobDetail)
}

class SetJobDetailsController: UIViewController {
  var jobType: JobType?
  
  var address: Address?
  var schedule: Schedule?
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
    performSegue(withIdentifier: StoryboardSegues.SetJobDetailsToSetPayment, sender: nil)
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
      
    } else if segue.identifier == StoryboardSegues.SetJobDetailsToSetDateTime {
      let destinationVC = segue.destination as? SetDateTimeController
      destinationVC?.delegate = self
      
    } else if segue.identifier == StoryboardSegues.SetJobDetailsToSetJobDetail {
      let destinationVC = segue.destination as? SetJobDetailController
      destinationVC?.delegate = self
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
  func addressSent(_ address: Address) {
    print("address sent")
//    print("""
//      \(address.direction)
//      \(address.latitude)
//      \(address.longitude)
//    """)
  }
  
  func dateTimeSent(_ schedule: Schedule) {
    print("date time sent")
    print("""
      \(schedule.bestTime)
      \(schedule.date)
    """)
  }
  
  func jobDetailSent(_ jobDetail: JobDetail) {
    print("job detail sent")
    print("""
      \(jobDetail.howDeepSnow)
      \(jobDetail.howLong)
      \(jobDetail.howWide)
      \(jobDetail.obstacles)
    """)
  }
  
  
}








































