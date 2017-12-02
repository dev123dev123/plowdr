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

class SlideMenuController: UITableViewController {
  weak var delegate: MenuOptionsDelegate?
  
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
  
}























