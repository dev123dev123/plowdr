//
//  Strings.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/16/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation

struct Strings {
  
  static let companyName = "Plowdr"
  static let paymentCurrency = "usd"
  
  struct Prices {
    static let monthlyPrice = 50 * 100  // This is in cents, i.e. $50 USD
    static let singlePrice = 60 * 100
    static let unlimitedPrice = 70 * 100
  }
  
  struct Server {
    static let baseURLString = "https://polar-refuge-65538.herokuapp.com/"
    static let baseURLFirebaseString = "https://us-central1-plowdr.cloudfunctions.net/"
//    static let baseURLString = "http://localhost:5000/"
    static let createEphemeralKeyURLString = "\(baseURLString)ephemeral-keys"
    static let chargeURLString = "\(baseURLString)charge"
    static let getTasksOrderedByHalfMonthsURLString = "\(baseURLFirebaseString)getTasksOrderedByHalfMonths"
  }
  
  struct Keys {
    struct Google {
      static let GoogleMapsAPI_KEY = "AIzaSyCdg6ngBe-SQJJtO5-faRBp5tA0rb4kLb0"
      static let GooglePlaceAPI_KEY = "AIzaSyA7a50ZLpKFzoUQ_99okU52HWG0ZeKGSQQ"
    }
    
    struct Stripe {
      static let API_Version = "2017-08-15"
      static let API_PublisableKey = "pk_test_5tLCGMOjIXQntqGLSRpZrCZV"
    }
  }
  
  struct ErrorMessages {
    static let bankNameEmpty = "Bank name value is empty."
    static let accountNumberEmpty = "Account number value is empty."
    static let routingNumberEmpty = "Routing value is empty."
    
    static let emailInvalid = "Email not valid."
    static let emailEmpty = "Email empty."
    static let userIdEmpty = "User id is empty."
    static let userIdInvalid = "User id is invalid."
    static let passwordAtLeast6 = "Password should contain at least 6 characters."
    static let mobileEmpty = "Mobile empty."
    static let firstNameEmpty = "First name empty."
    static let lastNameEmpty = "Last name empty."
    static let genericMessage = "Something went wrong, please try again."
    
    static let repeatedPasswordNotEqual = "Repeated password is not equal to the new password."
    static let oldPasswordInvalid = "Old Password is wrong, please try again."
    static let emailNotExist = "Missing email, login again please."
  }
  
  struct UI {
    static let obstaclesPlaceHolderText = "Ex. I have a stack of wood I will leave marked with a red flag"
    static let newSnowFall = "Next Snowfall"
    static let scheduleLabelClientTitle = "Schedule Plow"
    static let scheduleLabelDriverTitle = "View Jobs"
    
    static let paymentLabelClientTitle = "Payment"
    static let paymentLabelDriverTitle = "Earnings"
    
    static let earningsLabelTitle = "Current Earnings"
    
    static let updatedUserInfoSuccessfully = "User info was updated successfully."
    
    struct TaskState {
      static let isNextSnowFall = ("Waiting for snowfall", "")
      static let noneTitles = ("Looking for drivers..", "We'll alert you when we assign you a driver")
      static let assignedTitles = ("Driver Assigned", "We'll alert you when we dispatch a driver")
      static let enrouteTitles = ("Dispatched", "Driver en route")
      static let plowingTitles = ("Plowing", "")
      static let completedTitles = ("", "Completed")
    }
  }
  
  static let singleJobTitle = "Single Plow"
  static let monthlyJobTitle = "Monthly Plow"
  static let unlimitedJobTitle = "Unlimited Plow"
  
  static let singleJobDescription = """
  We use the latest machinery and the highest level of skill to make sure your're 100% satisfied with out service. We'll leave your driveway rid of all snow and plowed neatly to the edges.

  With our Single Plow service we dispatch a plow to your location for a one time snow removal service.

  With Plowdr you can stay up to date with our services and get alerts every time we plow!
  """
  static let monthlyJobDescription = """
    We use the latest machinery and the highest level of skill to make sure your're 100% satisfied with out service. We'll leave your driveway rid of all snow and plowed neatly to the edges.

    With our Monthly Plow service we perform the snow removal service when a snow fall of 4" or more occurs during a 24 hour period of 30 days.

    With Plowdr you can stay up to date with out services and get alerts every time we plow!

    (not to exceed 6 times)
  """
  static let unlimitedJobDescription = """
    We use the latest machinery and the highest level of skill to make sure you're 100% satisfied with our service. We'll leave your driveway rid of all snow and plowed neatly to the edges.

    Our Unlimited Plow service is the best value in the market. We perform the snow removal service when a snowfall of 4" or more occurs during a 24 hour period. This pricing allows you to pay for the season up front and make weather the least of your concerns.

    With Plowdr you can stay up to date with our services and get alerts every time we plow!

    (not to exceed 6 times monthly)
  """
  
}






































