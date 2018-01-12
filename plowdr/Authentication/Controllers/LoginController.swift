//
//  LoginController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginController: UIViewController {
  @IBOutlet weak var loginLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      loginLabel.isUserInteractionEnabled = true
      loginLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var forgotPasswordLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordLabelTapped))
      tapGesture.numberOfTouchesRequired = 1
      tapGesture.numberOfTapsRequired = 1
      
      forgotPasswordLabel.isUserInteractionEnabled = true
      forgotPasswordLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @objc func forgotPasswordLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.LoginToForgotPassword, sender: nil)
  }
  
  @objc func loginLabelTapped() {
    let email = emailTextField.text!
    let password = passwordTextField.text!
    
    loginLabel.alpha = 0.5
    loginLabel.isUserInteractionEnabled = false
    SVProgressHUD.show()
    User.login(
      email: email,
      password: password) { (user, error) in
        User.currentUser = user
        
        DispatchQueue.main.async {
          SVProgressHUD.dismiss()
          self.loginLabel.alpha = 1
          self.loginLabel.isUserInteractionEnabled = true
        }
        
        if let error = error {
          DispatchQueue.main.async {
            self.showErrorAlert(message: error.localizedDescription)
          }
        } else if let _ = user {
          DispatchQueue.main.async {
            self.performSegue(withIdentifier: StoryboardSegues.LoginToHome, sender: nil)
          }
        } else {
          
        }
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailTextField.delegate = self
    passwordTextField.delegate = self
    
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
    
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  @objc func backButtonTapped() {
    self.navigationController?.popViewController(animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ReachibilityManager.shared.addListener(listener: self)
    
    if !ReachibilityManager.shared.isNetworkAvailable {
      alertUserNoInternetConnectionAndDisableLoginLabel()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    ReachibilityManager.shared.removeListener(listener: self)
  }
}

extension LoginController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    return true
  }
  
}

extension LoginController: NetworkStatusListener {
  func alertUserNoInternetConnectionAndDisableLoginLabel() {
    loginLabel.alpha = 0.5
    loginLabel.isUserInteractionEnabled = false
    showErrorAlert(message: Strings.UI.noNetworkConnection)
  }
  
  func networkStatusDidChange(status: PlowdrNetworkStatus) {
    switch status {
    case .notReachable:
      DispatchQueue.main.async {
        self.alertUserNoInternetConnectionAndDisableLoginLabel()
      }
    case .reachable:
      DispatchQueue.main.async {
        self.loginLabel.alpha = 1
        self.loginLabel.isUserInteractionEnabled = true
      }
    }
  }
}























