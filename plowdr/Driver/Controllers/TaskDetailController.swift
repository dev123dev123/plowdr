//
//  TaskDetailController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class TaskDetailController: UIViewController {
  
  var childController: TaskDetailChildController?
  var currentTask: Task!
  @IBOutlet weak var clientNameLabel: UILabel!
  
  @IBOutlet weak var updateServiceLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateServiceLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      updateServiceLabel.isUserInteractionEnabled = true
      updateServiceLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.TaskDetailChild {
      let destinationVC = segue.destination as? TaskDetailChildController
      childController = destinationVC
      childController?.currentTask = currentTask
    } else if segue.identifier == StoryboardSegues.TaskDetailToUpdateService {
      let destinationVC = segue.destination as? UpdateServiceController
      destinationVC?.currentTask = currentTask
      destinationVC?.delegate = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    clientNameLabel.text = "Loading.."
    
    let clientUserId = currentTask.userId
    
    User.getUserFromDatabase(
    byUserId: clientUserId) { (client, error) in
      if let error = error {
        DispatchQueue.main.async {
          self.showErrorAlert(message: error.localizedDescription)
        }
      } else {
        if let client = client {
          DispatchQueue.main.async {
            self.clientNameLabel.text = "\(client.firstName) \(client.lastName)"
          }
        } else {
          DispatchQueue.main.async {
            self.showErrorAlert(message: "No client found.")
          }
        }
      }
    }
  }
  
  @IBAction func closeButtonTapped() {
    dismiss(animated: true)
  }
  
  @objc func updateServiceLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.TaskDetailToUpdateService, sender: nil)
  }
}

extension TaskDetailController: UpdateServiceDelegate {
  func didTaskChange() {
    dismiss(animated: true)
  }
}













































