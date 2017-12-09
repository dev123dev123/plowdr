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
  
  var dateSelected: (String, Date)?
  var bestTimeSelected = BestTime.morning
  
  let calendar = Calendar.current
  var dateSnowFallFuture: Date?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dateSnowFallFuture = calendar.date(byAdding: .year, value: 1, to: Date())
    
    if dateSelected == nil {
      dateSelected = (Strings.UI.newSnowFall, dateSnowFallFuture!)
    }
    
    let font = UIFont.init(name: "HiraMaruProN-W4", size: 17)
    segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
    
    datesToShow = generateDates(currentDate: Date())
    
    if bestTimeSelected == .morning {
      segmentedControl.selectedSegmentIndex = 0
    } else {
      segmentedControl.selectedSegmentIndex = 1
    }
    
    dateTimePickerView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let dateSelected = dateSelected {
      var counter = 0
      var indexFound = -1
      
      for dateToShow in datesToShow {
        if dateToShow.0 == dateSelected.0 {
          indexFound = counter
        }
        counter += 1
      }
      
      if indexFound >= 0 {
        dateTimePickerView.selectRow(indexFound, inComponent: 0, animated: false)
      }
    }
  }
  
  @IBAction func bestTimeSegmentedControlChanged() {
    if segmentedControl.selectedSegmentIndex == 0 {
      bestTimeSelected = .morning
    } else {
      bestTimeSelected = .afternoon
    }
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
    delegate?.dateTimeSent(dateSelected!, bestTime: bestTimeSelected)
    dismiss(animated: true)
  }
}

extension SetDateTimeController {
  func generateDates(currentDate: Date) -> [(String, Date)] {
    
    var dates = [(String, Date)]()
    
    if let oneMonthFromNow = Calendar.current.date(byAdding: .day, value: 30, to: currentDate) {
      let formatter = DateFormatter()
      formatter.dateFormat = "E, MMM dd"
      
      var dateLooped = currentDate
      
      while dateLooped <= oneMonthFromNow {
        dates.append( (formatter.string(from: dateLooped), dateLooped) )
          
        dateLooped = calendar.date(byAdding: .day, value: 1, to: dateLooped)!
      }
      
      
      dates.insert((Strings.UI.newSnowFall, dateSnowFallFuture!), at: 0)
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
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let dateToShow = datesToShow[row]
    
    dateSelected = dateToShow
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






































