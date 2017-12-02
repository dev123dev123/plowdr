//
//  JobsController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/16/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol JobsDelegate {
  func didRowTap()
}

class JobsController: UITableViewController {
  let cellId = "JobCellId"
  var delegate: JobsDelegate?
}

extension JobsController {
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JobCellController
    
    let values = [
      "month": "August ",
      "day": "28"
    ]
    cell.backgroundColor = .clear
    cell.initUI()
    cell.setLabelText(values: values, jobState: .scheduled)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didRowTap()
  }
  
}















