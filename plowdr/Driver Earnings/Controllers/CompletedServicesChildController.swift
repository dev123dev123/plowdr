//
//  CompletedServicesChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol CompletedServicesDelegate {
  func didRowTap(task: Task)
}

class CompletedServicesChildController: UITableViewController {
  let cellId = "CompletedCellId"
  var delegate: CompletedServicesDelegate?
  var tasks = [Task]()
}

extension CompletedServicesChildController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.row]
    delegate?.didRowTap(task: task)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompletedServiceCellController
    let task = tasks[indexPath.row]
    
    cell.initUI(task)
    
    return cell
  }
  
}






























