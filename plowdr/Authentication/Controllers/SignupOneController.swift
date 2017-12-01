//
//  SignupOneController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol SignupOneDelegate {
  var email: String { get }
  var mobile: String { get }
  var password: String { get }
}

class SignupOneController: UIViewController {
  var childController: SignupOneChildController?
  
  override func viewDidLoad() {
    super.viewDidLoad()       
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.SignupOneChild {
      let destinationVC = segue.destination as? SignupOneChildController
      childController = destinationVC
    } else if segue.identifier == StoryboardSegues.SignupOneToSignupTwo {
      let destinationVC = segue.destination as? SignupTwoController
      destinationVC?.delegate = self
    }
  }
  
  @IBOutlet weak var continueLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(continueLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      continueLabel.isUserInteractionEnabled = true
      continueLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func continueLabelTapped() {
    do {
      try User.areValuesValid(email: email, mobile: mobile, password: password)
    } catch AuthError.invalidFormInput(let description) {
      showErrorAlert(message: description)
      return
    } catch {
      showErrorAlert(message: error.localizedDescription)
      return
    }
    
    performSegue(withIdentifier: StoryboardSegues.SignupOneToSignupTwo, sender: nil)
  }
}

extension SignupOneController: SignupOneDelegate {
  var email: String {
    return childController?.emailTextField.text ?? ""
  }
  
  var mobile: String {
    return childController?.mobileTextField.text ?? ""
  }
  
  var password: String {
    return childController?.passwordTextField.text ?? ""
  }
}































