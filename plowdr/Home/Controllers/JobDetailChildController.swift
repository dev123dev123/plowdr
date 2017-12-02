//
//  JobDetailChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/1/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class JobDetailChildController: UITableViewController {
  
  @IBOutlet weak var borderView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    borderView.layer.borderColor = UIColor.white.cgColor
    borderView.layer.borderWidth = 5
  }
  
}
