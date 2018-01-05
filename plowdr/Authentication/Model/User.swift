//
//  User.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/28/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore

import Alamofire

enum  UserRole: String {
  case client
  case driver
}

enum AuthError: Error {
  case invalidFormInput(description: String)
  
  var localizedDescription: String {
    switch self {
    case .invalidFormInput(let description):
      return description
    }
  }
}

struct User {
  let id: String
  let email: String
  var firstName: String
  var lastName: String
  var mobile: String
  let customerId: String
  let role: String
  var vehicleInfo: String?
  
  var activeCardDescription: String?
  var address: Address?
  
  var bankName: String?
  var accountNumber: String?
  var routingNumber: String?
  
  init(
    id: String,
    email: String,
    firstName: String,
    lastName: String,
    mobile: String,
    customerId: String,
    activeCardDescription: String,
    role: String
  ) {
    self.id = id
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    self.mobile = mobile
    self.customerId = customerId
    self.activeCardDescription = activeCardDescription
    self.role = role
  }
  
  init?(dictionary: [String: Any]) {
    guard
      let id = dictionary["id"] as? String,
      let email = dictionary["email"] as? String,
      let firstName = dictionary["firstName"] as? String,
      let lastName = dictionary["lastName"] as? String,
      let mobile = dictionary["mobile"] as? String,
      let customerId = dictionary["customerId"] as? String,
      let role = dictionary["role"] as? String
    else {
      return nil
    }
    
    self.id = id
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    self.mobile = mobile
    self.customerId = customerId
    self.activeCardDescription = dictionary["activeCardDescription"] as? String
    self.role = role
    self.vehicleInfo = dictionary["vehicleInfo"] as? String
    
    self.bankName = dictionary["bankName"] as? String
    self.accountNumber = dictionary["accountNumber"] as? String
    self.routingNumber = dictionary["routingNumber"] as? String
    
    if
      let addressLine = dictionary["address"] as? String,
      let latitude = dictionary["latitude"] as? Double,
      let longitude = dictionary["longitude"] as? Double
    {
      self.address = Address(
        addressLine: addressLine,
        city: "",
        state: "",
        postalCode: "",
        country: "",
        latitude: latitude,
        longitude: longitude)
    }
  }
}

extension User {
  private static let db = Database.db
  private static let dbUsers = db.collection("users")
  private static let dbPrices = db.collection("prices")
  
  public static var currentUser: User?
  
  static func getPriceDataBy(
    plan: String,
    width: Int,
    length: Int,
    completion: @escaping ((String, Double)?) -> Void
  ) {

    let query = dbPrices
                  .whereField("length", isEqualTo: length)
                  .whereField("width", isEqualTo: width)
                  .whereField("plan", isEqualTo: plan)
    
    query.getDocuments { (querySnap, error) in
      if let _ = error {
        completion(nil)
      } else {
        if let document = querySnap?.documents.first {
          if
            let drivewaySize = document["drivewaySize"] as? String,
            let price = document["price"] as? Double
          {
            completion((drivewaySize, price))
            return
          }
        }
        
        completion(nil)
      }
    }
  }
  
  static func updatePushToken(
    userId: String,
    pushToken: String,
    completion: @escaping (Error?) -> Void
  ) {
    let userDocument = dbUsers.document(userId)
    
    var values = [String: Any]()
    values["pushToken"] = pushToken
    
    userDocument.updateData(values) { (error) in
      completion(error)
    }
  }
  
  static func updateDriverBankInfo(
    driverId: String,
    bankName: String,
    accountNumber: String,
    routingNumber: String,
    completion: @escaping (Error?) -> Void
  ) {
    let driverDocument = dbUsers.document(driverId)
    
    let bankName = bankName.trimmingCharacters(in: CharacterSet.whitespaces)
    let accountNumber = accountNumber.trimmingCharacters(in: CharacterSet.whitespaces)
    let routingNumber = routingNumber.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if bankName.count < 1 {
      let error = NSError(domain: "UpdateDriverBankInfo", code: 0, userInfo: [
        NSLocalizedDescriptionKey: Strings.ErrorMessages.bankNameEmpty
        ])
      completion(error)
      return
    }
    
    if accountNumber.count < 1 {
      let error = NSError(domain: "UpdateDriverBankInfo", code: 0, userInfo: [
        NSLocalizedDescriptionKey: Strings.ErrorMessages.accountNumberEmpty
        ])
      completion(error)
      return
    }
    
    if routingNumber.count < 1 {
      let error = NSError(domain: "UpdateDriverBankInfo", code: 0, userInfo: [
        NSLocalizedDescriptionKey: Strings.ErrorMessages.routingNumberEmpty
        ])
      completion(error)
      return
    }

    var fieldsToUpdate = [String: Any]()
    fieldsToUpdate["bankName"] = bankName
    fieldsToUpdate["accountNumber"] = accountNumber
    fieldsToUpdate["routingNumber"] = routingNumber
    
    driverDocument.updateData(fieldsToUpdate) { (error) in
      completion(error)
    }
  }
  
  static func resetPassword(
    email: String,
    completion: @escaping (Error?) -> Void
  ) {
    let email = email.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if !isValid(email: email) {
      let error = NSError(domain: "Auth", code: 0, userInfo: [
        NSLocalizedDescriptionKey: Strings.ErrorMessages.emailInvalid
      ])
      completion(error)
    }
    
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
      completion(error)
    }
  }
  
  static func changePassword(
    oldPassword: String,
    newPassword: String,
    repeatedNewPassword: String,
    completion: @escaping (Error?) -> Void
  ) {
    guard let email = User.currentUser?.email else {
      let error = NSError(domain: "ChangePassword", code: 0, userInfo: [
        NSLocalizedDescriptionKey: Strings.ErrorMessages.emailNotExist
        ])
      completion(error)
      return
    }
    
    if oldPassword.count < 1 {
      let error = NSError(domain: "ChangePassword", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Old \(Strings.ErrorMessages.passwordAtLeast6)"
      ])
      completion(error)
      return
    }
    
    if newPassword.count < 1 {
      let error = NSError(domain: "ChangePassword", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "New \(Strings.ErrorMessages.passwordAtLeast6)"
        ])
      completion(error)
      return
    }
    
    if repeatedNewPassword.count < 1 {
      let error = NSError(domain: "ChangePassword", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Repeated \(Strings.ErrorMessages.passwordAtLeast6)"
        ])
      completion(error)
      return
    }
    
    if newPassword != repeatedNewPassword {
      let error = NSError(domain: "ChangePassword", code: 0, userInfo: [
        NSLocalizedDescriptionKey: Strings.ErrorMessages.repeatedPasswordNotEqual
        ])
      completion(error)
      return
    }
    
    let user = Auth.auth().currentUser
    let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
    
    user?.reauthenticate(with: credential, completion: { (error) in
      if let error = error {
        if let nsError = error as? NSError {
          if nsError.code == AuthErrorCode.wrongPassword.rawValue {
            let error = NSError(domain: "ResetPassword", code: 0, userInfo: [
              NSLocalizedDescriptionKey: Strings.ErrorMessages.oldPasswordInvalid
            ])
            
            completion(error)
          }
        }
        
        completion(error)
      } else {
        user?.updatePassword(to: newPassword, completion: { (error) in
          if let error = error {
            completion(error)
          } else {
            completion(nil)
          }
        })
      }
    })
  }
  
  static func listenUpdatesOnUser(
    byUserId userId: String,
    completion: @escaping (User) -> Void
  ) {
    let userDocument = dbUsers.document(userId)
    
    userDocument.addSnapshotListener { (snap, error) in
      if let document = snap {
        if document.exists {
          if let user = User.init(dictionary: document.data()) {
            completion(user)
          }
        }
      }
    }
  }
  
  static func update(
    byUserId userId: String?,
    withFirstName firstName: String,
    andLastName lastName: String,
    andMobile mobile: String,
    completion: @escaping (Error?) -> Void
  ) {
    do {
      try isValueValid(userId: userId)
      try areValuesValid(firstName: firstName, lastName: lastName, mobile: mobile)
    } catch AuthError.invalidFormInput(let description) {
      let error = NSError(domain: "SetAccount", code: 0, userInfo: [
        NSLocalizedDescriptionKey: description
        ])
      
      completion(error)
      return
    } catch {
      completion(error)
      return
    }
    
    let userDocument = dbUsers.document(userId!)
    
    var fieldsToUpdate = [String: Any]()
    fieldsToUpdate["firstName"] = firstName
    fieldsToUpdate["lastName"] = lastName
    fieldsToUpdate["mobile"] = mobile
    
    userDocument.updateData(fieldsToUpdate) { (error) in
      completion(error)
    }
  }
  
  static func completeCharge(
    stripeId: String,
    amount: Int,
    customerId: String,
    capture: Bool = true,
    completion: @escaping (Error?, String?) -> Void
  ) {
    let urlString = Strings.Server.chargeURLString
    
    var parameters = [String: Any]()
    parameters["customerId"] = customerId
    parameters["stripeId"] = stripeId
    parameters["amount"] = amount
    parameters["capture"] = capture
    
    Alamofire.request(
      urlString,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    )
    .responseJSON(completionHandler: { (response) in
      if response.response?.statusCode == 200 {
        if
          let json = response.value as? [String: Any],
          let chargeId = json["chargeId"] as? String
        {
          completion(nil, chargeId)
          return
        }
        
        let error = NSError(
          domain: "Payment",
          code: 0,
          userInfo: [
            NSLocalizedDescriptionKey: "Charge Id was not sent."
          ])
        completion(error, nil)
      } else {
        var errorMessage = "Someting happened, try again please."
        
        if
          let json = response.result.value as? [String: Any],
          let message = json["message"] as? String
        {
          errorMessage = message
        }
        
        let error = NSError(
          domain: "Payment",
          code: 0,
          userInfo: [
            NSLocalizedDescriptionKey: errorMessage
          ])
        completion(error, nil)
      }
    })
  }
  
  static func createEphimeralKey(
    userId: String,
    apiVersion: String,
    completion: @escaping ([String: Any]?, Error?) -> Void
  ) {
    let urlString = Strings.Server.createEphemeralKeyURLString
    
    let parameters: [String: Any] = [
      "customerId": userId,
      "stripeVersion": apiVersion
    ]

    Alamofire.request(
      urlString,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
      ).responseJSON(completionHandler: { (response) in
        
        if let json = response.result.value as? [String: Any] {
          completion(json, nil)
          return
        }
        
        let error = NSError(
          domain: "Stripe",
          code: 0,
          userInfo: [
            NSLocalizedDescriptionKey: "Key wasn't generated."
          ]
        )
        completion(nil, error)
      })
  }
  
  static func signUp(
    email: String,
    mobile: String,
    password: String,
    firstName: String,
    lastName: String,
    completion: @escaping (User?, Error?) -> Void
  ) {
    var user: User?
    var customerId: String?
    
    do {
      try areValuesValid(email: email, mobile: mobile, password: password)
      try areValuesValid(firstName: firstName, lastName: lastName)
    } catch AuthError.invalidFormInput(let description) {
      let error = NSError(domain: "Auth", code: 0, userInfo: [
        NSLocalizedDescriptionKey: description
        ])
      
      completion(nil, error)
      return
    } catch {
      completion(nil, error)
      return
    }
    
    Ax.serial(tasks: [
      
      { done in
        Auth.auth().createUser(
          withEmail: email,
          password: password,
          completion: { (firUser: FirebaseAuth.User?, error: Error?) in
            done(error)
        })
      },
      
      { done in
        let urlString = Strings.Server.createCustomerURLString
        
        let parameters : [String: Any] = [
          "email": email
        ]
        
        Alamofire.request(
          urlString,
          method: .post,
          parameters: parameters,
          encoding: JSONEncoding.default
        ).responseJSON(completionHandler: { (response) in
          
            if let json = response.result.value as? [String: Any] {
              print(json)
              
              if let custoId = json["customerId"] as? String {
                customerId = custoId
              }
              
            }
          
            done(nil)
          })
      },
      
      { done in
        let userDocument = dbUsers.document()
        
        var values = [String: Any]()
        values["id"] = userDocument.documentID
        values["email"] = email
        values["mobile"] = mobile
        values["firstName"] = firstName
        values["lastName"] = lastName
        values["customerId"] = customerId
        values["role"] = UserRole.client.rawValue
        
        user = User(dictionary: values)
        
        userDocument.setData(values, completion: { (error) in
          done(error)
        })
      }
      
    ]) { (error) in
      completion(user, error)
    }
  }
  
  static func login(
    email: String,
    password: String,
    completion: @escaping (User?, Error?) -> Void
  ) {
    var userEmail: String!
    var userFound: User?
    
    do {
      try areValuesValid(email: email, password: password)
    } catch AuthError.invalidFormInput(let description) {
      let error = NSError(domain: "Auth", code: 0, userInfo: [
        NSLocalizedDescriptionKey: description
      ])
      
      completion(nil, error)
      return
    } catch {
      completion(nil, error)
      return
    }
    
    Ax.serial(tasks: [
      { done in
        Auth.auth().signIn(
          withEmail: email,
          password: password) { (firUser: FirebaseAuth.User?, error: Error?) in
            if let firUser = firUser {
              userEmail = firUser.email!
              done(nil)
              return
            }
            
            done(error)
        }
      },
      { done in
        getUserFromDatabase(byUserEmail: userEmail, completion: { (user, error) in
          userFound = user
          
          done(error)
        })
      }
      
    ]) { (error) in
      completion(userFound, error)
    }
  }
  
//  static func getCustomerFromStripe(byCustomerId customerId: String)
  
  static func logout() {
    try? Auth.auth().signOut()
    User.currentUser = nil
  }
  
  public static func updateUser(
    byUserId userId: String,
    valuesToUpdate: [String: Any],
    completion: @escaping (Error?) -> Void) {
    
    dbUsers.document("\(userId)").updateData(valuesToUpdate) { (error) in
      completion(error)
    }
  }
  
  static func getUserFromDatabase(
    byUserId userId: String,
    completion: @escaping (User?, Error?) -> Void
  ) {
    let query = dbUsers.document(userId)
    
    query.getDocument { (snap, error) in
      if let error = error {
        completion(nil, error)
      } else {
        if let document = snap {
          if let user = User.init(dictionary: document.data()) {
            completion(user, nil)
            return
          }
        }
        
        let error = NSError(domain: "Auth", code: 0, userInfo: [
          NSLocalizedDescriptionKey: "No user found."
        ])
        
        completion(nil, error)
      }
    }
  }
  
  private static func getUserFromDatabase(
    byUserEmail userEmail: String,
    completion: @escaping (User?, Error?) -> Void
  ) {
    let query = dbUsers.whereField("email", isEqualTo: userEmail)
    query.getDocuments { (snap, error) in
      if let error = error {
        completion(nil, error)
      } else {
        if let document = snap?.documents.first {
          if let user = User.init(dictionary: document.data()) {
            completion(user, nil)
            return
          }
        }
        
        let error = NSError(domain: "Auth", code: 0, userInfo: [
          NSLocalizedDescriptionKey: "No user found."
          ])
        completion(nil, error)
      }
    }
  }
  
  private static func getCurrentUserFromFirAuth(completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
    var handle: AuthStateDidChangeListenerHandle?
    
    guard Auth.auth().currentUser != nil else {
      let error = NSError(domain: "Auth", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "No user found."
      ])
      
      completion(nil, error)
      return
    }
    
    handle = Auth.auth().addStateDidChangeListener { (auth, firUser) in
      
      if let handle = handle {
        Auth.auth().removeStateDidChangeListener(handle)
      }
      
      if let firUser = firUser {
        completion(firUser, nil)
        return
      }
      
      let error = NSError(domain: "Auth", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "No user found."
        ])
      completion(nil, error)
    }
  }
  
  static func getCurrentUserLoggedIn(completion: @escaping (User?, Error?) -> Void) {
    var userEmail: String!
    var userFound: User?
    
//    if Auth.auth().currentUser == nil {
//      completion(nil, nil)
//      return
//    }
    
    guard Auth.auth().currentUser != nil else {
      completion(nil, nil)
      return
    }
    
    Ax.serial(tasks: [
      { done in
        getCurrentUserFromFirAuth(completion: { (firUser, error) in
          if let firUser = firUser {
            userEmail = firUser.email!
            done(nil)
            return
          }
          
          done(error)
        })
      },
      { done in
        getUserFromDatabase(byUserEmail: userEmail, completion: { (user, error) in
          userFound = user
          done(error)
        })
      }
    ]) { (error) in
      completion(userFound, error)
    }
  }
}

extension User {
  static func isValueValid(userId: String?) throws {
    guard var userId = userId else {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.userIdInvalid)
    }
    
    userId = userId.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if userId.count < 1 {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.userIdEmpty)
    }
  }
  
  static func areValuesValid(
    email: String,
    password: String
    ) throws {
    
    let email = email.trimmingCharacters(in: CharacterSet.whitespaces)
    let password = password.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if !isValid(email: email) {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.emailInvalid)
    }
    
    if email.count < 1 {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.emailEmpty)
    }
    
    if password.count < 1 {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.passwordAtLeast6)
    }
  }
  
  static func isValid(email: String) -> Bool {
    let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }
  
  static func areValuesValid(
    email: String,
    mobile: String,
    password: String
    ) throws {
    try areValuesValid(email: email, password: password)
    
    let mobile = mobile.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if mobile.count < 1 {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.mobileEmpty)
    }
  }
  
  static func areValuesValid(
    firstName: String,
    lastName: String,
    mobile: String? = nil
  ) throws {
    let firstName = firstName.trimmingCharacters(in: CharacterSet.whitespaces)
    let lastName = lastName.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if firstName.count < 1 {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.firstNameEmpty)
    }
    
    if lastName.count < 1 {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.lastNameEmpty)
    }
    
    if let mobile = mobile,
       mobile.count < 1
    {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.mobileEmpty)
    }
  }
}

































