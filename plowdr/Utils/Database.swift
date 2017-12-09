//
//  Database.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/2/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Database {
  static var db = { () -> Firestore in
    let db = Firestore.firestore()
    
    let settings = FirestoreSettings()
    settings.isPersistenceEnabled = false
    
    db.settings = settings
    
    return db
  }()
}
