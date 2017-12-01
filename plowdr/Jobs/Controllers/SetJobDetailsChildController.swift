//
//  SetJobDetailsChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class SetJobDetailsChildController: UITableViewController {
  var jobType: JobType?
  var delegate: SetJobDetailsDelegate?
  
  @IBOutlet weak var jobTypeView: UIView!
  
  @IBOutlet weak var addressView: UIView! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressViewTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      addressView.isUserInteractionEnabled = true
      addressView.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var dateTimeView: UIView! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTimeViewTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      dateTimeView.isUserInteractionEnabled = true
      dateTimeView.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var jobDetailView: UIView! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(jobDetailViewTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      jobDetailView.isUserInteractionEnabled = true
      jobDetailView.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var jobTypeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUIValues()
  }
  
  func setUIValues() {
    jobTypeView.layer.borderWidth = 5
    jobTypeView.layer.borderColor = UIColor.white.cgColor
    
    addressView.layer.borderWidth = 5
    addressView.layer.borderColor = UIColor.white.cgColor
    
    dateTimeView.layer.borderWidth = 5
    dateTimeView.layer.borderColor = UIColor.white.cgColor
    
    jobDetailView.layer.borderWidth = 5
    jobDetailView.layer.borderColor = UIColor.white.cgColor
  }

  @objc func addressViewTapped() {
    delegate?.addressSelected()
  }
  
  @objc func dateTimeViewTapped() {
    delegate?.dateTimeSelected()
  }
  
  @objc func jobDetailViewTapped() {
    delegate?.jobDetailSelected()
  }
}

extension SetJobDetailsChildController {
  
  
  
}
































