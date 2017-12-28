//
//  SlideMenuController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/8/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol MenuOptionsDelegate: class {
  func didScheduleJobTap()
  func didBookingsTap()
  func didPaymentTap()
  func didAddressTap()
  func didAccountTap()
  func didSupportTap()
  func didLogoutTap()
}

enum SlideMenuType {
  case client
  case driver
}

class SlideMenuController: UITableViewController {
  weak var delegate: MenuOptionsDelegate?
  
  var slideMenuType: SlideMenuType = .client
  
  @IBOutlet weak var scheduleOrViewPlowsLabel: UILabel!
  @IBOutlet weak var paymentOrEarningsLabel: UILabel!
  
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var scheduleJobCell: UITableViewCell!
  @IBOutlet weak var bookingsCell: UITableViewCell!
  @IBOutlet weak var paymentCell: UITableViewCell!
  @IBOutlet weak var addressCell: UITableViewCell!
  @IBOutlet weak var accountCell: UITableViewCell!
  @IBOutlet weak var supportCell: UITableViewCell!
  @IBOutlet weak var logoutCell: UITableViewCell!
}

extension SlideMenuController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let userId = User.currentUser?.id {
      User.listenUpdatesOnUser(byUserId: userId, completion: { (user) in
        DispatchQueue.main.async {
          self.userLabel.text = "\(user.firstName) \(user.lastName)"
        }
      })
    }
    

    
    var fullName = ""
    
    if let firstName = User.currentUser?.firstName {
      fullName += firstName
    }
    
    if let lastName = User.currentUser?.lastName {
      fullName += " \(lastName)"
    }
    
    userLabel.text = fullName
    
    if User.currentUser!.role == UserRole.client.rawValue {
      scheduleOrViewPlowsLabel.text = Strings.UI.scheduleLabelClientTitle
      paymentOrEarningsLabel.text = Strings.UI.paymentLabelClientTitle
    } else {
      scheduleOrViewPlowsLabel.text = Strings.UI.scheduleLabelDriverTitle
      paymentOrEarningsLabel.text = Strings.UI.paymentLabelDriverTitle
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    
    tableView.deselectRow(at: indexPath, animated: true)
   
    if cell === scheduleJobCell {
      delegate?.didScheduleJobTap()
    } else if bookingsCell === cell {
      delegate?.didBookingsTap()
    } else if paymentCell ===  cell {
      delegate?.didPaymentTap()
    } else if addressCell === cell {
      delegate?.didAddressTap()
    } else if accountCell === cell {
      delegate?.didAccountTap()
    } else if supportCell === cell {
      delegate?.didSupportTap()
    } else if logoutCell === cell {
      delegate?.didLogoutTap()
    }
  }

  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    let height = super.tableView(tableView, heightForRowAt: indexPath)
    
    if User.currentUser!.role == UserRole.driver.rawValue {
      if bookingsCell === cell {
        return 0
      } else if addressCell === cell {
        return 0
      }
    }
    
    return height
  }
  
}

//@IBOutlet weak var scheduleJobCell: UITableViewCell!
//@IBOutlet weak var bookingsCell: UITableViewCell!
//@IBOutlet weak var paymentCell: UITableViewCell!
//@IBOutlet weak var addressCell: UITableViewCell!
//@IBOutlet weak var accountCell: UITableViewCell!
//@IBOutlet weak var supportCell: UITableViewCell!
//@IBOutlet weak var logoutCell: UITableViewCell!
























