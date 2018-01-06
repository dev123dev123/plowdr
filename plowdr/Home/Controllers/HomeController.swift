//
//  HomeController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class HomeController: BaseViewController {
  
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
  
  @objc func notificationGot(notification: Notification) {
    DispatchQueue.main.async {
      self.sideMenuManager.hideSideMenu()
      
      self.dismiss(animated: true, completion: {
        
      })
      
      if let dataString = notification.userInfo?[Strings.PushNotification.dataKey] as? String {
        if let data = dataString.data(using: .utf8) {
          if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dictionary = jsonObject as? [String: Any] {
              if let task = Task(dictionary: dictionary) {
                
                if User.currentUser!.role == UserRole.client.rawValue {
                  self.performSegue(withIdentifier: StoryboardSegues.HomeToJobDetail, sender: task)
                } else {
                  self.performSegue(withIdentifier: StoryboardSegues.HomeToTaskDetail, sender: task)
                }
                
              }
            }
          }
        }
      }
      
    }
  }
  
  deinit {
    ReachibilityManager.shared.removeListener(listener: self)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlowNotification"), object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if
      let data = UserDefaults.standard.string(forKey: Strings.PushNotification.dataKey),
      let message = UserDefaults.standard.string(forKey: Strings.PushNotification.messageKey)
    {
      
      UserDefaults.standard.set(nil, forKey: Strings.PushNotification.dataKey)
      UserDefaults.standard.set(nil, forKey: Strings.PushNotification.messageKey)
      UserDefaults.standard.synchronize()
      
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification"), object: nil, userInfo: [
        Strings.PushNotification.dataKey: data,
        Strings.PushNotification.messageKey: message
        ]
      )
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ReachibilityManager.shared.addListener(listener: self)
    NotificationCenter.default.addObserver(self, selector: #selector(notificationGot(notification:)), name: NSNotification.Name(rawValue: "PlowNotification"), object: nil)
    
    paymentContextImplementation = STPPaymentContextImplementation()
    paymentContextImplementation.hostViewController = self

    if User.currentUser!.role == UserRole.client.rawValue {
      labelView.isHidden = true
      containerView.isHidden = true
      scheduleLabel.isHidden = true
    } else {
      self.labelView.isHidden = true
      self.scheduleLabel.isHidden = true
      self.containerView.isHidden = false
    }
    
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
  
  func hideSideMenu() {
    sideMenuManager.hideSideMenu()
  }

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.HomeToSetAccount {
      let destinationVC = segue.destination as? SetAccountController
      destinationVC?.setAccountType = SetAccountType.client
    } else if segue.identifier == StoryboardSegues.HomeToJobs {
      let destinationVC = segue.destination as? JobsController
      destinationVC?.delegate = self
    } else if segue.identifier == StoryboardSegues.HomeToSetAddress {
      let destinationVC = segue.destination as? SetAddressController
      destinationVC?.startedFromSideMenu = true
    } else if segue.identifier == StoryboardSegues.HomeToTaskDetail {
      let destinationVC = segue.destination as? TaskDetailController
      destinationVC?.currentTask = sender as! Task
    } else if segue.identifier == StoryboardSegues.HomeToJobDetail {
      let destinationVC = segue.destination as? JobDetailController
      destinationVC?.currentTask = sender as! Task
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
  
  func didRowTap(with task: Task) {
    if User.currentUser!.role == UserRole.client.rawValue {
      performSegue(withIdentifier: StoryboardSegues.HomeToJobDetail, sender: task)
    } else {
      performSegue(withIdentifier: StoryboardSegues.HomeToTaskDetail, sender: task)
    }
  }
}

extension HomeController: MenuOptionsDelegate {
  
  func didScheduleJobTap() {
    if User.currentUser!.role == UserRole.client.rawValue {
      performSegue(withIdentifier: StoryboardSegues.HomeToChooseJob, sender: nil)
    }
    sideMenuManager.toggleShowSideMenu()
  }
  
  func didBookingsTap() {
    sideMenuManager.toggleShowSideMenu()
  }
  
  func didPaymentTap() {
//    performSegue(withIdentifier: StoryboardSegues.HomeToSetPayment, sender: nil)
    
    if User.currentUser!.role == UserRole.client.rawValue {
      paymentContextImplementation.showPaymentFormOnHostViewController()
    } else {
      performSegue(withIdentifier: StoryboardSegues.HomeToEarnings, sender: nil)
    }
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

extension HomeController: NetworkStatusListener {
  func networkStatusDidChange(status: NetworkStatus) {
    switch status {
    case .notReachable:
      break
    case .reachable:
      break
    }
  }
}


































