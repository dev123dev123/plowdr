//
//  SetJobDetailChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class SetJobDetailChildController: UITableViewController {
  @IBOutlet weak var obstaclesDescriptionCell: UITableViewCell!
  @IBOutlet weak var wideCell: UITableViewCell!
  @IBOutlet weak var longCell: UITableViewCell!
  @IBOutlet weak var deepCell: UITableViewCell!
  
  var howDeepSnowValue: String?
//  {
//    didSet {
//      deepDrivewayLabel.text = howDeepSnowValue
//    }
//  }
  
  var howLongValue: String?
//  {
//    didSet {
//      longDrivewayLabel.text = howLongValue
//    }
//  }
//
  var howWideValue: String?
//  {
//    didSet {
//      wideDrivewayLabel.text = howWideValue
//    }
//  }
//
  var obstaclesValue: String?
//  {
//    get {
//      if obstaclesTextView.text == Strings.UI.obstaclesPlaceHolderText {
//        return nil
//      } else {
//        return obstaclesTextView.text
//      }
//    }
//    set {
//      self.obstaclesValue = newValue
//    }
//  }
  
  @IBOutlet weak var wideDrivewayLabel: UILabel!
  @IBOutlet weak var longDrivewayLabel: UILabel!
  @IBOutlet weak var deepDrivewayLabel: UILabel!
  @IBOutlet weak var obstaclesTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let howWideValue = howWideValue {
       wideDrivewayLabel.text = howWideValue
    }
    
    if let howLongValue = howLongValue {
      longDrivewayLabel.text = howLongValue
    }
    
    if let howDeepSnowValue = howDeepSnowValue {
      deepDrivewayLabel.text = howDeepSnowValue
    }
    
    if let obstaclesValue = obstaclesValue {
      obstaclesTextView.text = obstaclesValue
      obstaclesTextView.textColor = UIColor.black
    } else {
      obstaclesTextView.text = Strings.UI.obstaclesPlaceHolderText
      obstaclesTextView.textColor = UIColor.lightGray
    }
    
    obstaclesTextView.delegate = self
    
    let (doneButton, toolBarButton)  = createDoneButtonOnKeyboard()
    obstaclesTextView.inputAccessoryView = toolBarButton
    
    doneButton.target = self
    doneButton.action = #selector(dismissKeyboard)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  func getObstaclesDescription() -> String? {
    if obstaclesTextView.text == Strings.UI.obstaclesPlaceHolderText {
      return nil
    } else {
      return obstaclesTextView.text
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.SetJobDetailChildToJobDetailList {
      let destinationVC = segue.destination as? JobDetailListController
      var values = [String: Any]()
      
      if let jobListType = sender as? JobListType {
        switch jobListType {
        case .howDeepSnow:
          values["jobListValue"] = howDeepSnowValue
        case .howLong:
          values["jobListValue"] = howLongValue
        case .howWide:
          values["jobListValue"] = howWideValue
        }
        
        values["jobListType"] = jobListType
      }
      destinationVC?.jobListValues = values
      destinationVC?.delegate = self
    }
  }
}

extension SetJobDetailChildController {
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if cell === obstaclesDescriptionCell {
      cell.selectionStyle = .none
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    
    guard cell !== obstaclesDescriptionCell else {
      return
    }
    
    var jobListType = JobListType.howDeepSnow
    
    if cell === wideCell {
      jobListType = .howWide
    } else if cell === longCell {
      jobListType = .howLong
    }
    
    performSegue(withIdentifier: StoryboardSegues.SetJobDetailChildToJobDetailList, sender: jobListType)
  }
}

extension SetJobDetailChildController: JobDetailEntrySelected {
  func howDeepSnowSelected(_ value: String) {
    howDeepSnowValue = value
    deepDrivewayLabel.text = value
  }
  
  func howLongSelected(_ value: String) {
    longDrivewayLabel.text = value
    howLongValue = value
  }
  
  func howWideSelected(_ value: String) {
    howWideValue = value
    wideDrivewayLabel.text = value
  }
}

extension SetJobDetailChildController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == Strings.UI.obstaclesPlaceHolderText {
      textView.text = ""
      textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.text = Strings.UI.obstaclesPlaceHolderText
      textView.textColor = .lightGray
    }
  }
}






























