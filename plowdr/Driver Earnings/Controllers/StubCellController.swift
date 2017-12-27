//
//  StubCell.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class StubCellController: UITableViewCell {
  @IBOutlet weak var datesLabel: UILabel!
  @IBOutlet weak var borderView: UIView!
  
  func initUI(_ dateFromToTitle: String) {
    borderView.layer.borderWidth = 5.0
    borderView.layer.borderColor = UIColor.white.cgColor
    datesLabel.text = dateFromToTitle
  }
}
