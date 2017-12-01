//
//  ContainerController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/8/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

protocol SideMenuManager {
  func toggleShowSideMenu()
}

class ContainerController: UIViewController {
  enum SideMenuState {
    case expanded
    case notExpanded
  }
  
  var homeNavigationController: UINavigationController!
  var homeController: HomeController!
  var slideMenuController: SlideMenuController!
  
  var sideMenuState: SideMenuState = .notExpanded
  let centerPanelExpandedOffset: CGFloat = 60
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let homeStoryboard = UIStoryboard(name: "HomeView", bundle: Bundle.main)
    let slideMenuStoryboard = UIStoryboard(name: "SlideMenuView", bundle: Bundle.main)
    
    homeController = homeStoryboard.instantiateViewController(withIdentifier: "HomeView") as? HomeController
    homeController.sideMenuManager = self
    slideMenuController = slideMenuStoryboard.instantiateViewController(withIdentifier: "SlideMenuView") as? SlideMenuController
    slideMenuController.delegate = homeController
    
    homeNavigationController = UINavigationController(rootViewController: homeController)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    homeNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    
    view.addSubview(homeNavigationController.view)
    addChildViewController(homeNavigationController)
    homeNavigationController.didMove(toParentViewController: self)
    
    view.insertSubview(slideMenuController.view, at: 0)
    addChildViewController(slideMenuController)
    slideMenuController.didMove(toParentViewController: self)
  }
  
  func animateContainerMovingToX(targetPosition:CGFloat) {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: .curveEaseInOut,
      animations: {
        self.homeNavigationController.view.frame.origin.x = targetPosition
      }
    )
  }
}

extension ContainerController: UIGestureRecognizerDelegate {
  @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
//    let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
    
    switch recognizer.state {
    case .began:
      if sideMenuState == .notExpanded {
        
      }
      break
    case .changed:
      if let rview = recognizer.view {
        if sideMenuState == .expanded ||
          recognizer.translation(in: view).x >= 0 {
          rview.center.x = rview.center.x + recognizer.translation(in: view).x
          recognizer.setTranslation(CGPoint.zero, in: view)
        }
      }
      break
    case .ended:
      
      if let rview = recognizer.view {
        let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
        
        if hasMovedGreaterThanHalfway {
          showSideMenu()
        } else {
          hideSideMenu()
        }
      }

      break
    default:
      break
    }
  }
}

extension ContainerController: SideMenuManager {
  func showSideMenu() {
    let targetPosition = homeNavigationController.view.frame.width - centerPanelExpandedOffset
    animateContainerMovingToX(targetPosition: targetPosition)
    sideMenuState = .expanded
  }
  
  func hideSideMenu() {
    let targetPosition: CGFloat = 0
    animateContainerMovingToX(targetPosition: targetPosition)
    sideMenuState = .notExpanded
  }
  
  func toggleShowSideMenu() {
    var targetPosition: CGFloat = 0
    if case SideMenuState.notExpanded = sideMenuState {
      targetPosition = homeNavigationController.view.frame.width - centerPanelExpandedOffset
      sideMenuState = .expanded
    } else {
      sideMenuState = .notExpanded
    }
    
    animateContainerMovingToX(targetPosition: targetPosition)
  }
}



































