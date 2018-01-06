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
  
  @objc func updateLabelTapped() {
    let enrouteSelected = childController?.isEnrouteSelected ?? false
    let currrentlyPlowingSelected = childController?.isCurrentlyPlowingSelected ?? false
    let completedSelected = childController?.isCompletedSelected ?? false
    
    var state = currentTask.state
    
    if state == .completed {
      dismiss(animated: true)
      return
    }
    
    if enrouteSelected {
      state = .enroute
    } else if currrentlyPlowingSelected {
      state = .plowing
    } else if completedSelected {
      state = .completed
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







































