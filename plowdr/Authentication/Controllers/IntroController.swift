//
//  IntroVC.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

class IntroController: UIViewController {
  @IBOutlet weak var loginLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      loginLabel.isUserInteractionEnabled = true
      loginLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var signupLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signupLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      signupLabel.isUserInteractionEnabled = true
      signupLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for family: String in UIFont.familyNames
    {
      print("\(family)")
      for names: String in UIFont.fontNames(forFamilyName: family)
      {
        print("== \(names)")
      }
    }
    
    setupLabels()
    
    SVProgressHUD.show()
    User.getCurrentUserLoggedIn { (user, _) in
      DispatchQueue.main.async {
        SVProgressHUD.dismiss()
      }
      
      if let user = user {
        User.currentUser = user
        DispatchQueue.main.async {
          self.performSegue(withIdentifier: StoryboardSegues.IntroToHome, sender: nil)
        }
      }
    }
  }
  
  
  
  @objc func loginLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.IntroToLogin, sender: nil)
  }
  
  @objc func signupLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.IntroToSignup, sender: nil)
  }
  
  func setupLabels() {
    loginLabel.layer.borderColor = UIColor(red: 154.0/255.0, green: 173.0/255.0, blue: 193.0/255.0, alpha: 1.0).cgColor
    loginLabel.layer.borderWidth = 5
    loginLabel.layer.cornerRadius = 5
    
    signupLabel.layer.cornerRadius = 5
    signupLabel.layer.masksToBounds = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
}




































