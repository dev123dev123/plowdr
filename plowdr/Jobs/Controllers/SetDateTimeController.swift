//
//  SetDateTimeController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit


class SetDateTimeController: UIViewController {
  var delegate: JobDetailsDelegate?
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  @IBOutlet weak var dateTimePickerView: UIPickerView!
  
  var datesToShow = [(String, Date)]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let font = UIFont.init(name: "HiraMaruProN-W4", size: 17)
    segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
    
    datesToShow = generateDates(currentDate: Date())
    dateTimePickerView.delegate = self
  }
  
  @IBOutlet weak var saveLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      saveLabel.isUserInteractionEnabled = true
      
      saveLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBAction func closeButtonTapped() {
    dismiss(animated: true)
  }
  
  @objc func saveLabelTapped() {
    let schedule = Schedule(
      date: Date(),
      bestTime: .morning
    )
    
    delegate?.dateTimeSent(schedule)
    dismiss(animated: true)
  }
}

extension SetDateTimeController {
  func generateDates(currentDate: Date) -> [(String, Date)] {
    let calendar = Calendar.current
    var dates = [(String, Date)]()
    
    if let oneMonthFromNow = Calendar.current.date(byAdding: .day, value: 30, to: currentDate) {
      let formatter = DateFormatter()
      formatter.dateFormat = "E, MMM dd"
      
      var dateLooped = currentDate
      
      while dateLooped <= oneMonthFromNow {
        dates.append( (formatter.string(from: dateLooped), dateLooped) )
          
        dateLooped = calendar.date(byAdding: .day, value: 1, to: dateLooped)!
      }
      
      dates.insert(("Next Snowfall", Date()), at: 0)
    }
    
    return dates
  }
}

extension SetDateTimeController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return datesToShow.count
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    var label: UILabel
    
    if let view = view as? UILabel {
      label = view
    } else {
      label = UILabel()
    }
    
    let dateToShow = datesToShow[row]
    
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.font = UIFont(name: "HiraMaruProN-W4", size: 17)
    
    label.text = dateToShow.0
    
    return label
  }
}






































