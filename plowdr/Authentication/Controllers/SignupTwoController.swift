//
//  SignupTwoController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupTwoController: UIViewController {
  var childController: SignupTwoChildController?
  var delegate: SignupOneDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    titleLabel.font = UIFont(name: "AGStencil", size: 35)
    titleLabel.textColor = UIColor.white
    titleLabel.textAlignment = .center
    titleLabel.text = "plowdr"
    titleLabel.textColor = UIColor.init(red: 113.0/255.0, green: 168.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    navigationItem.titleView = titleLabel
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 32))
    button.setImage(UIImage(named: "back-button"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    
    let showMenu = UIBarButtonItem(customView: button)
    navigationItem.leftBarButtonItem = showMenu
  }
  
  @objc func backButtonTapped() {
    self.navigationController?.popViewController(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.SignupTwoChild {
      let destinationVC = segue.destination as? SignupTwoChildController
      childController = destinationVC
    }
  }
  
  @IBOutlet weak var signupLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signupLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      signupLabel.isUserInteractionEnabled = true
      signupLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func signupLabelTapped() {
    guard let delegate = delegate else {
      // show appropiate error message
      return
    }
    
    guard let childController = childController else {
      // show appropiate error message
      return
    }
    
    let email = delegate.email
    let mobile = delegate.mobile
    let password = delegate.password
    let firstName = childController.firstNameTextField.text!
    let lastName = childController.lastNameTextField.text!
    
    SVProgressHUD.show()
    signupLabel.isUserInteractionEnabled = false
    signupLabel.alpha = 0.5
    User.signUp(
      email: email,
      mobile: mobile,
      password: password,
      firstName: firstName,
      lastName: lastName) { (newUser, error) in
        User.currentUser = newUser
        
        DispatchQueue.main.async {
          self.signupLabel.isUserInteractionEnabled = true
          self.signupLabel.alpha = 1
          SVProgressHUD.dismiss()
        }
        
        if let _ = newUser {
          DispatchQueue.main.async {
            self.performSegue(withIdentifier: StoryboardSegues.SignupTwoToHome, sender: nil)
          }
        } else if let error = error {
          DispatchQueue.main.async {
            self.showErrorAlert(message: error.localizedDescription)
          }
        } else {
          DispatchQueue.main.async {
            self.showErrorAlert(message: Strings.ErrorMessages.genericMessage)
          }
        }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ReachibilityManager.shared.addListener(listener: self)
    
    if (!ReachibilityManager.shared.isNetworkAvailable) {
      self.alertUserNoInternetConnectionAndDisableSignupLabel()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    ReachibilityManager.shared.removeListener(listener: self)
  }
  
}

extension SignupTwoController: NetworkStatusListener {
  func alertUserNoInternetConnectionAndDisableSignupLabel() {
    self.signupLabel.isUserInteractionEnabled = false
    self.signupLabel.alpha = 0.5
    self.showErrorAlert(message: Strings.UI.noNetworkConnection)
  }
  
  func networkStatusDidChange(status: PlowdrNetworkStatus) {
    switch status {
    case .notReachable:
      DispatchQueue.main.async {
        self.alertUserNoInternetConnectionAndDisableSignupLabel()
      }
      break
    case .reachable:
      DispatchQueue.main.async {
        self.signupLabel.isUserInteractionEnabled = true
        self.signupLabel.alpha = 1
      }
      break
    }
  }
}































