//
//  CompletedServiceCellController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class CompletedServiceCellController: UITableViewCell {
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var dateFromToLabel: UILabel!
  
  @IBOutlet weak var borderView: UIView!
  
  let formatter = { () -> DateFormatter in
    let f = DateFormatter()
    f.dateFormat = "MM/dd/yyyy"
    return f
  }()
  
  func initUI(_ task: Task) {
    borderView.layer.borderWidth = 5.0
    borderView.layer.borderColor = UIColor.white.cgColor
    
    userNameLabel.text = task.clientName
    dateFromToLabel.text = formatter.string(from: task.dateSelected)
  }
  
}
