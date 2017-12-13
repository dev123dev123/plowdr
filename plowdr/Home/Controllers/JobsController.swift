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
  
  var tasks = [Task]()
  let formatter = DateFormatter()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let currentUserId = User.currentUser?.id else {
      self.showErrorAlert(message: "User Id not found, please log in again.")
      return
    }
    
    SVProgressHUD.show()
    Task.listenNewAndChangesOnTasksForClient(userId: currentUserId) { (tasks) in
      SVProgressHUD.dismiss()
      
      self.delegate?.hasJobs(result: tasks.count > 0)
      self.tasks = tasks
      
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
    return tasks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JobCellController
    
    let task = tasks[indexPath.row]
    var month = ""
    var day = ""
    
    if task.isNextSnowFall {
      month = Strings.UI.newSnowFall
    } else {
      formatter.dateFormat = "MMMM"
      month = formatter.string(from: task.dateSelected)
      
      formatter.dateFormat = "d"
      day = formatter.string(from: task.dateSelected)
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















