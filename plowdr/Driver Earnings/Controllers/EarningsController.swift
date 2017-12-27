//
//  EarningsController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class EarningsController: UIViewController {
  
  var childController: EarningsChildController?
  
  var groupedTasks = [[String: Any]]()
  var currentGroupedTask = [String: Any]()
  
  var isCurrentEarnings = true
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var viewServicesLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewServicesLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      viewServicesLabel.isUserInteractionEnabled = true
      viewServicesLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func viewServicesLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.EarningsToCompletedServices, sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.EarningsChild {
      let destinationVC = segue.destination as? EarningsChildController
      destinationVC?.isCurrentEarnings = isCurrentEarnings
      destinationVC?.delegate = self
      childController = destinationVC
    } else if segue.identifier == StoryboardSegues.EarningsToPayStubs {
      let destinationVC = segue.destination as? PayStubsController
      destinationVC?.groupedTasks = groupedTasks
    } else if segue.identifier == StoryboardSegues.EarningsToCompletedServices {
      let destinationVC = segue.destination as? CompletedServicesController
      var tasks = [Task]()
      
      if let tasksJSON = currentGroupedTask["tasks"] as? [[String: Any]] {
        tasks = tasksJSON.flatMap { Task.init(dictionary: $0) }
      }
      
      destinationVC?.tasks = tasks
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = "Loading.."
    
    if isCurrentEarnings {
      titleLabel.text = Strings.UI.earningsLabelTitle
      
      if let driverId = User.currentUser?.id {
        SVProgressHUD.show()
        Task.getTasksOrderedByHalfMonths(byDriverId: driverId, completion: { (error, tasks) in
          DispatchQueue.main.async {
            SVProgressHUD.dismiss()
          }
          
          if let error = error {
            
          } else {
            self.groupedTasks = tasks
            
            if tasks.count > 0 {
              DispatchQueue.main.async {
                self.currentGroupedTask = tasks[0]
                self.childController?.setUIValues(groupedTask: self.currentGroupedTask)
              }
            }
          }
        })
      }
    } else {
      self.titleLabel.text = self.currentGroupedTask["id"] as? String
      self.childController?.setUIValues(groupedTask: currentGroupedTask)
    }
  }
  
  
  @IBAction func cancelButtonTapped() {
    dismiss(animated: true)
  }
}

extension EarningsController: EarningsDelegate {
  func didBankInfoTap() {
    performSegue(withIdentifier: StoryboardSegues.EarningsToBankInfo, sender: nil)
  }
  
  func didPayStubsTap() {
    performSegue(withIdentifier: StoryboardSegues.EarningsToPayStubs, sender: nil)
  }
}







































