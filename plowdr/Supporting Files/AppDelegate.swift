//
//  AppDelegate.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/7/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import GooglePlaces
import GoogleMaps
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var comesFromTerminatedPushNotification = false

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    GMSServices.provideAPIKey(Strings.Keys.Google.GoogleMapsAPI_KEY)
    GMSPlacesClient.provideAPIKey(Strings.Keys.Google.GooglePlaceAPI_KEY)
    STPPaymentConfiguration.shared().publishableKey = Strings.Keys.Stripe.API_PublisableKey
    
    FirebaseApp.configure()
    
    configurePushNotificationFeature(application: application)
    
    if launchOptions?[.remoteNotification] != nil {
      comesFromTerminatedPushNotification = true
    }
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    ReachibilityManager.shared.startMonitoring()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    ReachibilityManager.shared.stopMonitoring()
  }


}

extension AppDelegate {
  
  func configurePushNotificationFeature(application: UIApplication) {
    let center = UNUserNotificationCenter.current()
    
    center.delegate = self
    center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
      print("permission granted: \(granted)")
      
      guard granted else { return }
      
      self.getNotificationsSettings()
    }
    
    Messaging.messaging().delegate = self
  }
  
  func getNotificationsSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      print("Notification settings: \(settings)")
      
      guard settings.authorizationStatus == .authorized else { return }
      
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
//  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//    let tokenParts = deviceToken.map { String(format: "%02.2hhx", $0)}
//
//    let token = tokenParts.joined()
//    print("Device Token: \(token)")
//    print("FCM Token: \(InstanceID.instanceID().token())")
//  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("failed to register: \(error)")
  }
  
  // background, terminated
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo as? [String: Any]
    
    if comesFromTerminatedPushNotification {
      if let data = userInfo?[Strings.PushNotification.dataKey] as? String,
         let message = userInfo?[Strings.PushNotification.messageKey] as? String
      {
        
        UserDefaults.standard.set(data, forKey: Strings.PushNotification.dataKey)
        UserDefaults.standard.set(message, forKey: Strings.PushNotification.messageKey)
        UserDefaults.standard.synchronize()
      }
      comesFromTerminatedPushNotification = false
    } else {
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification"), object: nil, userInfo: userInfo)
    }
  }
  
  // foreground
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo as? [String: Any]
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification"), object: nil, userInfo: userInfo)
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    User.getCurrentUserLoggedIn { (user, error) in
      if let userId = user?.id {
        User.updatePushToken(userId: userId, pushToken: fcmToken, completion: { (error) in
          print(error?.localizedDescription)
        })
      }
    }
  }
}



























