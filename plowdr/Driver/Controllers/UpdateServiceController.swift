//
//  UpdateServiceController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/11/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol UpdateServiceDelegate {
  func didTaskChange()
}

enum TaskStateError: Error {
  case invalideNewState(description: String)
}

class UpdateServiceController: BaseViewController {
  var currentTask: Task!
  var delegate: UpdateServiceDelegate?
  
  @IBOutlet weak var updateLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      updateLabel.isUserInteractionEnabled = true
      updateLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  var childController: UpdateServiceChildController?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.UpdateServiceChild {
      let destinationVC = segue.destination as? UpdateServiceChildController
      childController = destinationVC
      childController?.currentTask = currentTask
    }
  }
  
  @IBAction func closeButtonTapped(_ sender: Any) {
    dismiss(animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ReachibilityManager.shared.addListener(listener: self)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    ReachibilityManager.shared.removeListener(listener: self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !ReachibilityManager.shared.isNetworkAvailable {
      showErrorAlert(message: Strings.UI.noNetworkConnection)
    }
  }
  
  func isValidNewState(newState: TaskState, lastState: TaskState) throws {
    
    if (
        (lastState == TaskState.plowing)
          &&
        (newState == TaskState.enroute)
    ) {
      throw TaskStateError.invalideNewState(description: Strings.UI.invalidNewTaskState)
    }
    
    
    if (
      (lastState == TaskState.completed)
      &&
      (newState == TaskState.enroute || newState == TaskState.plowing)
      ) {
      throw TaskStateError.invalideNewState(description: Strings.UI.invalidNewTaskState)
    }
  }
  
  @objc func updateLabelTapped() {
    let enrouteSelected = childController?.isEnrouteSelected ?? false
    let currrentlyPlowingSelected = childController?.isCurrentlyPlowingSelected ?? false
    let completedSelected = childController?.isCompletedSelected ?? false
    
    var state = currentTask.state
    
    if state == .completed {
      showErrorAlert(message: Strings.UI.taskStateAlreadyCompleted)
      return
    }
    
    if enrouteSelected {
      state = .enroute
    } else if currrentlyPlowingSelected {
      state = .plowing
    } else if completedSelected {
      state = .completed
    } else {
      showErrorAlert(message: Strings.UI.notSelectedTaskState)
      return
    }
    
    do {
      try isValidNewState(newState: state, lastState: currentTask.state)
    } catch TaskStateError.invalideNewState(let description) {
      showErrorAlert(message: description)
      return
    } catch {
      showErrorAlert(message: error.localizedDescription)
      return
    }
    
    // same state
    if state == currentTask.state {
      dismiss(animated: true)
      return
    }
    
    SVProgressHUD.show()
    Task.changeState(taskId: currentTask.id, newState: state) { (error) in
      DispatchQueue.main.async {
        SVProgressHUD.dismiss()
      }
      
      if let error = error {
        DispatchQueue.main.async {
          self.showErrorAlert(message: error.localizedDescription)
        }
      } else {
        DispatchQueue.main.async {
          self.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
              self.delegate?.didTaskChange()
            }
          })
        }
      }
    }
  }
}

extension UpdateServiceController: NetworkStatusListener {
  func disableUpdateLabel() {
    updateLabel.alpha = 0.5
    updateLabel.isUserInteractionEnabled = false
  }
  
  func networkStatusDidChange(status: PlowdrNetworkStatus) {
    switch status {
    case .notReachable:
      DispatchQueue.main.async {
        self.disableUpdateLabel()
      }
    case .reachable:
      DispatchQueue.main.async {
        self.updateLabel.alpha = 1
        self.updateLabel.isUserInteractionEnabled = true
      }
    }
  }
}







































