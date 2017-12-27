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
  @IBOutlet weak var subtitleLabel: UILabel!
  var formatter = DateFormatter()
  var task: Task?
  
  func initValues() {
    guard let task = task else {
      return
    }
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    borderView.layer.borderWidth = 5
    borderView.layer.borderColor = UIColor.white.cgColor
    subtitleLabel.isHidden = false
    
    let state = task.state.getStringValue()

    if User.currentUser!.role == UserRole.client.rawValue {
      var title = ""
      var subtitle = ""
      
      if task.isNextSnowFall {
        let (t, _) = Strings.UI.TaskState.isNextSnowFall
        title = t
        subtitleLabel.isHidden = true
      } else {
        let (t, s) = Task.getTitlesBy(taskState: task.state)
        title = t
        subtitle = s
        
        if task.state == .completed {
          formatter.dateFormat = "MMMM"
          let month = formatter.string(from: task.dateSelected)
          
          formatter.dateFormat = "d"
          let day = formatter.string(from: task.dateSelected)
          
          setTitleLabelWithSpecificFont(month: month, day: day)
          subtitleLabel.text = s
          return
        } else if task.state == .plowing {
          subtitleLabel.isHidden = true
        }
      }
      
      titleLabel.text = title
      subtitleLabel.text = subtitle
    } else {
      let clientName = task.clientName
      
      titleLabel.isHidden = false
      
      titleLabel.text = clientName
      subtitleLabel.text = state
    }
  }
  
  func showTitleLabel(show: Bool) {
    titleLabel.isHidden = !show
  }
  
  func showSubtitleLabel(show: Bool) {
    subtitleLabel.isHidden = !show
  }
  
  func setTitleLabelWithSpecificFont(
    month: String,
    day: String
  ) {
    let monthFont = UIFont(name: "HiraMaruProN-W4", size: 20)!
    let dayFont = UIFont(name: "HiraMaruProN-W4", size: 33)!
    
    let monthDictionary = [
      NSAttributedStringKey.font: monthFont
    ]
    let dayDictionary = [
      NSAttributedStringKey.font: dayFont
    ]
    
    let monthAttributedString = NSMutableAttributedString(string: month, attributes: monthDictionary)
    let dayAttributedString = NSMutableAttributedString(string: day, attributes: dayDictionary)
    
    monthAttributedString.append(dayAttributedString)
    
    titleLabel.attributedText = monthAttributedString
  }
}


















































