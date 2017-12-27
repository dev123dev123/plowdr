//
//  PayStubsChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol PayStubsDelegate {
  func didRowTap(groupedTask: [String: Any])
}

class PayStubsChildController: UITableViewController {
  let cellId = "StubCellId"
  var delegate: PayStubsDelegate?
  var groupedTasks = [[String: Any]]()
}

extension PayStubsChildController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let groupedTask = groupedTasks[indexPath.row]
    delegate?.didRowTap(groupedTask: groupedTask)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupedTasks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StubCellController
    let groupedTask = groupedTasks[indexPath.row]
    let dateFromToText = groupedTask["id"] as! String
    
    cell.initUI(dateFromToText)
    
    return cell
  }
}



































