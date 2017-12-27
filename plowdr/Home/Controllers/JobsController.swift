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
  func didRowTap(with task: Task)
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
    
    if User.currentUser!.role == UserRole.client.rawValue {
      Task.listenNewAndChangesOnTasksForClient(userId: currentUserId) { (tasks) in
        SVProgressHUD.dismiss()
        
        self.delegate?.hasJobs(result: tasks.count > 0)
        self.tasks = tasks
//        self.tasks = tasks.filter {
//          return $0.state != TaskState.none
//
//        }
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    } else {
      Task.listenNewAndChangesOnTasksForDriver(driverId: currentUserId, completion: { (tasks) in
        SVProgressHUD.dismiss()
        
        self.tasks = tasks
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      })
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
    let task = tasks[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JobCellController
    cell.task = task
    cell.initValues()
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.row]
    
    guard let currentUser = User.currentUser else {
      return
    }
    
//    if (currentUser.role != UserRole.client.rawValue) {
      delegate?.didRowTap(with: task)
//    }
  }
  
}















