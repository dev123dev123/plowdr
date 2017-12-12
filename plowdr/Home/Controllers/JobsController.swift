//
//  JobsController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/16/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol JobsDelegate {
  func didRowTap()
  func hasJobs(result: Bool)
}

class JobsController: UITableViewController {
  let cellId = "JobCellId"
  var delegate: JobsDelegate?
  
  var jobs = [Job]()
  let formatter = DateFormatter()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let currentUserId = User.currentUser?.id else {
      self.showErrorAlert(message: "User Id not found, please log in again.")
      return
    }
    
    SVProgressHUD.show()
    Job.listenNewJobs(userId: currentUserId) { (jobs) in
      SVProgressHUD.dismiss()
      
      self.delegate?.hasJobs(result: jobs.count > 0)
      self.jobs = jobs
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
}

extension JobsController {
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return jobs.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JobCellController
    
    let job = jobs[indexPath.row]
    var month = ""
    var day = ""
    
    if job.isNextSnowFall {
      month = Strings.UI.newSnowFall
    } else {
      formatter.dateFormat = "MMMM"
      month = formatter.string(from: job.date)
      
      formatter.dateFormat = "d"
      day = formatter.string(from: job.date)
    }
    
    let values = [
      "month": month,
      "day": day
    ]
    cell.backgroundColor = .clear
    cell.initUI()
    cell.setLabelText(values: values, jobState: .scheduled)
    cell.showSubtitleLabel(show: false)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didRowTap()
  }
  
}















