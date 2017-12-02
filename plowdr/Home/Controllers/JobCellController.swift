//
//  JobCellController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/1/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

enum JobState {
  case scheduled
}

class JobCellController: UITableViewCell {
  
  @IBOutlet weak var borderView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  var jobState: JobState?
  
  func initUI() {
    contentView.backgroundColor = .clear
    borderView.layer.borderWidth = 5
    borderView.layer.borderColor = UIColor.white.cgColor
  }
  
  func setLabelText(values: [String: String], jobState: JobState) {
    self.jobState = jobState
    
//    if let jobState = jobState {
    
    switch jobState {
    case .scheduled:
      let monthFont = UIFont(name: "HiraMaruProN-W4", size: 20)!
      let dayFont = UIFont(name: "HiraMaruProN-W4", size: 33)!
      
      let monthDictionary = [
        NSAttributedStringKey.font: monthFont
      ]
      let dayDictionary = [
        NSAttributedStringKey.font: dayFont
      ]
      
      let monthText = values["month"]
      let dayText = values["day"]
      
      let monthAttributedString = NSMutableAttributedString(string: monthText!, attributes: monthDictionary)
      let dayAttributedString = NSMutableAttributedString(string: dayText!, attributes: dayDictionary)
      
      monthAttributedString.append(dayAttributedString)
      
      titleLabel.attributedText = monthAttributedString
      break
    }
      
//    }
  }
}


















































