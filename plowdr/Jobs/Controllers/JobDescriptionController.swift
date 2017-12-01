//
//  JobDescriptionController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/16/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class JobDescriptionController: UIViewController {
  var jobType: JobType!
  var jobDescriptionAccepted = {}
  
  @IBOutlet weak var jobTypeTitle: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var blurView: UIView!
  
  
  @IBOutlet weak var okayLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(okayLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      okayLabel.isUserInteractionEnabled = true
      okayLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func okayLabelTapped() {
    dismiss(animated: true) {
      self.jobDescriptionAccepted()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUIValues()
  }
  
  deinit {
    print("job descriptip controller died.")
  }
  
  @IBAction func okayButtonTapped() {

  }
  
  func setUIValues() {
    
    switch jobType! {
    case .single:
      jobTypeTitle.text = Strings.singleJobTitle
      descriptionTextView.text = Strings.singleJobDescription
    case .monthly:
      jobTypeTitle.text = Strings.monthlyJobTitle
      descriptionTextView.text = Strings.monthlyJobDescription
    case .unlimited:
      jobTypeTitle.text = Strings.unlimitedJobTitle
      descriptionTextView.text = Strings.unlimitedJobDescription
    }
    
    okayLabel.layer.cornerRadius = 5
    okayLabel.layer.masksToBounds = true
    
    containerView.layer.cornerRadius = 5
    containerView.layer.masksToBounds = true
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    visualEffectView.frame = blurView.bounds
    blurView.addSubview(visualEffectView)
  }
  
}














































