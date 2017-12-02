//
//  Strings.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/16/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation

struct Strings {
  
  struct Keys {
    struct Google {
      static let GoogleMapsAPI_KEY = "AIzaSyCdg6ngBe-SQJJtO5-faRBp5tA0rb4kLb0"
      static let GooglePlaceAPI_KEY = "AIzaSyA7a50ZLpKFzoUQ_99okU52HWG0ZeKGSQQ"
    }
  }
  
  struct ErrorMessages {
    static let emailInvalid = "Email not valid."
    static let emailEmpty = "Email empty."
    static let passwordAtLeast6 = "Password should containt at least 6 characters."
    static let mobileEmpty = "Mobile empty."
    static let firstNameEmpty = "First name empty."
    static let lastNameEmpty = "Last name empty."
    static let genericMessage = "Something went wrong, please try again."
  }
  
  struct UI {
    static let obstaclesPlaceHolderText = "Ex. I have a stack of wood I will leave marked with a red flag"
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





































