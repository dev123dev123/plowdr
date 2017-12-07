//
//  HomeController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
  
  var sideMenuManager: SideMenuManager!
  var paymentContextImplementation: STPPaymentContextImplementation!
  
  @IBOutlet weak var scheduleLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scheduleLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      scheduleLabel.isUserInteractionEnabled = true
      scheduleLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var labelView: UIView!
  
  @objc func scheduleLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.HomeToChooseJob, sender: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    paymentContextImplementation = STPPaymentContextImplementation()
    paymentContextImplementation.hostViewController = self
    
    labelView.isHidden = true
    containerView.isHidden = true
    scheduleLabel.isHidden = true
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 39, height: 33))
    button.setBackgroundImage(UIImage(named: "settings-icon"), for: .normal)
    button.clipsToBounds = true
    button.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(showMenuButtonTapped), for: .touchUpInside)

    let showMenu = UIBarButtonItem(customView: button)
    
    navigationItem.leftBarButtonItem = showMenu
    
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    titleLabel.font = UIFont(name: "AGStencil", size: 35)
    titleLabel.textColor = UIColor.white
    titleLabel.textAlignment = .center
    titleLabel.text = "plowdr"
    navigationItem.titleView = titleLabel
    
    
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  // MARK: Private methods
  @objc func showMenuButtonTapped() {
    sideMenuManager.toggleShowSideMenu()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.HomeToSetAccount {
      let destinationVC = segue.destination as? SetAccountController
      destinationVC?.setAccountType = SetAccountType.client
    } else if segue.identifier == StoryboardSegues.HomeToJobs {
      let destinationVC = segue.destination as? JobsController
      destinationVC?.delegate = self
    }
  }
  
}

extension HomeController: JobsDelegate {
  func hasJobs(result: Bool) {
    DispatchQueue.main.async {
      
      if result {
        self.labelView.isHidden = true
        self.scheduleLabel.isHidden = true
        self.containerView.isHidden = false
      } else {
        self.labelView.isHidden = false
        self.scheduleLabel.isHidden = false
        self.containerView.isHidden = true
      }
    }
  }
  
  func didRowTap() {
    performSegue(withIdentifier: StoryboardSegues.HomeToJobDetail, sender: nil)
  }
}

extension HomeController: MenuOptionsDelegate {
  
  func didScheduleJobTap() {
    performSegue(withIdentifier: StoryboardSegues.HomeToChooseJob, sender: nil)
    sideMenuManager.toggleShowSideMenu()
  }
  
  func didBookingsTap() {
    sideMenuManager.toggleShowSideMenu()
  }
  
  func didPaymentTap() {
//    performSegue(withIdentifier: StoryboardSegues.HomeToSetPayment, sender: nil)
    paymentContextImplementation.showPaymentFormOnHostViewController()
    sideMenuManager.toggleShowSideMenu()
  }
  
  func didAddressTap() {
    performSegue(withIdentifier: StoryboardSegues.HomeToSetAddress, sender: nil)
    sideMenuManager.toggleShowSideMenu()
  }
  
  func didAccountTap() {
    performSegue(withIdentifier: StoryboardSegues.HomeToSetAccount, sender: nil)
    sideMenuManager.toggleShowSideMenu()
  }
  
  func didSupportTap() {
    sideMenuManager.toggleShowSideMenu()
  }
  
  func didLogoutTap() {
    sideMenuManager.toggleShowSideMenu()
    
    User.logout()
    parent?.navigationController?.backTo(type: IntroController.self)
  }
  
}


































