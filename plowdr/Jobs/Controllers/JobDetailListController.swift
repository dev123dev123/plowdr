//
//  JobDetailListController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class JobDetailListController: BaseViewController {

//  var jobListType: JobListType?
  var delegate: JobDetailEntrySelected?
  var jobListValues = [String: Any]()
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.JobDetailListChild {
      let destinationVC = segue.destination as? JobDetailListChildController
      destinationVC?.jobListValues = jobListValues
      destinationVC?.delegate = delegate
    }
  }
  
}
//
//extension JobDetailListController: JobDetailEntrySelected {
//  func howDeepSnowSelected(_ value: String) {
//    
//  }
//  
//  func howLongSelected(_ value: String) {
//  
//  }
//  
//  func howWideSelected(_ value: String) {
//    
//  }
//}
































