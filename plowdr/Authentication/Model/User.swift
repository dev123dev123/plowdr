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
  let email: String
  let firstName: String
  let lastName: String
  let mobile: String
  
  init(
    email: String,
    firstName: String,
    lastName: String,
    mobile: String
  ) {
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    self.mobile = mobile
  }
  
  init?(dictionary: [String: Any]) {
    guard
      let email = dictionary["email"] as? String,
      let firstName = dictionary["firstName"] as? String,
      let lastName = dictionary["lastName"] as? String,
      let mobile = dictionary["mobile"] as? String
    else {
      return nil
    }
    
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    self.mobile = mobile
  }
}

extension User {
  private static let db = Firestore.firestore()
  private static let dbUsers = db.collection("users")
  
  public static var currentUser: User?
  
  static func signUp(
    email: String,
    mobile: String,
    password: String,
    firstName: String,
    lastName: String,
    completion: @escaping (User?, Error?) -> Void
  ) {
    var user: User?
    
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
        let userDocument = dbUsers.document()
        
        var values = [String: Any]()
        values["id"] = userDocument.documentID
        values["email"] = email
        values["mobile"] = mobile
        values["firstName"] = firstName
        values["lastName"] = lastName
        
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
  
  static func logout() {
    try? Auth.auth().signOut()
    User.currentUser = nil
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
//    query.getDocument(completion: { (snap, error) in
//      if let user = snap.flatMap({ User.init(dictionary: $0.data()) }) {
//        completion(user, nil)
//        return
//      }
//
//      let error = NSError(domain: "Auth", code: 0, userInfo: [
//        NSLocalizedDescriptionKey: "No user found."
//        ])
//      completion(nil, error)
//    })
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
    lastName: String
    ) throws {
    let firstName = firstName.trimmingCharacters(in: CharacterSet.whitespaces)
    let lastName = lastName.trimmingCharacters(in: CharacterSet.whitespaces)
    
    if firstName.count < 1 {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.firstNameEmpty)
    }
    
    if lastName.count < 1 {
      throw AuthError.invalidFormInput(description: Strings.ErrorMessages.lastNameEmpty)
    }
  }
}
































