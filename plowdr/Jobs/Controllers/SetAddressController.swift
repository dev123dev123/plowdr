//
//  SetAddressController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/20/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import SVProgressHUD
import INTULocationManager

class SetAddressController: BaseViewController {
  
  var startedFromSideMenu = false
  
  let geocoder = GMSGeocoder()
  
  var streetNumber = ""
  var route = ""
  var neighborhood = ""
  var locality = ""
  var administrativeAreaLevel1 = ""
  var country = ""
  var postalCode = ""
  var postalCodeSuffix = ""
  
  var addressSelected: Address?
  
  var delegate: JobDetailsDelegate?
  @IBOutlet weak var addressTextView: UITextField!
  @IBOutlet weak var addressMapView: GMSMapView!
  @IBOutlet weak var addressLabel: UILabel!
  
  
  var lastPositionMoved = CLLocationCoordinate2D(latitude: 36.778259, longitude: -119.417931)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addressMapView.delegate = self
    
    // comes from flow of creating a job
    if let addressSelected = addressSelected {
      print("""
        on viewDidLoad:
        latitude: \(addressSelected.latitude)
        longitude: \(addressSelected.longitude)
        """)
      
      let camera = GMSCameraPosition.camera(withLatitude: addressSelected.latitude, longitude: addressSelected.longitude, zoom: 15.0)
      self.addressMapView.camera = camera
      self.addressLabel.text = addressSelected.addressLine
      lastPositionMoved.latitude = addressSelected.latitude
      lastPositionMoved.longitude = addressSelected.longitude
    } else {
      if let address = User.currentUser?.address {
        // comes from side menu
        let camera = GMSCameraPosition.camera(withLatitude: address.latitude, longitude: address.longitude, zoom: 15.0)
        self.addressMapView.camera = camera
        
        self.addressLabel.text = address.addressLine
        lastPositionMoved.latitude = address.latitude
        lastPositionMoved.longitude = address.longitude
      } else {
         // comes from flow of creating a job
        SVProgressHUD.show()
        INTULocationManager.sharedInstance().requestLocation(
          withDesiredAccuracy: INTULocationAccuracy.neighborhood,
          timeout: 10.0,
          delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
            DispatchQueue.main.async {
              SVProgressHUD.dismiss()
            }
            
            let latitude =  currentLocation?.coordinate.latitude ?? 36.778259
            let longitude = currentLocation?.coordinate.longitude ?? -119.417931
            
            self.lastPositionMoved = CLLocationCoordinate2D(
              latitude: latitude,
              longitude: longitude
            )
            
            if (status == INTULocationStatus.success) {
              // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
              // currentLocation contains the device's current location
              
            }
            else if (status == INTULocationStatus.timedOut) {
              // Wasn't able to locate the user with the requested accuracy within the timeout interval.
              // However, currentLocation contains the best location available (if any) as of right now,
              // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
            }
            else {
              // An error occurred, more info is available by looking at the specific status returned.
            }
            
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
            self.addressMapView.camera = camera
            
            self.addressSelected = Address(
              addressLine: "",
              city: "",
              state: "",
              postalCode: "",
              country: "",
              latitude: camera.target.latitude,
              longitude: camera.target.longitude
            )
        }
      }
    }
  }
  
  
  @IBOutlet weak var saveLabel: UILabel! {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveLabelTapped))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      
      saveLabel.isUserInteractionEnabled = true
      saveLabel.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBAction func closeButtonTapped() {
    dismiss(animated: true)
  }
  
  @objc func saveLabelTapped() {
    addressSelected = Address(
      addressLine: addressLabel.text ?? "",
      city: "",
      state: "",
      postalCode: "",
      country: "",
      latitude: lastPositionMoved.latitude,
      longitude: lastPositionMoved.longitude
    )
    
    if startedFromSideMenu {
      if let currentUserId = User.currentUser?.id {
        var values = [String: Any]()
        values["address"] = addressSelected!.addressLine
        values["latitude"] = addressSelected!.latitude
        values["longitude"] = addressSelected!.longitude
        
        SVProgressHUD.show()
        saveLabel.alpha = 0.5
        saveLabel.isUserInteractionEnabled = false
        User.updateUser(byUserId: currentUserId, valuesToUpdate: values, completion: { (error) in
          DispatchQueue.main.async {
            self.saveLabel.alpha = 1
            self.saveLabel.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            
            if let error = error {
              self.showErrorAlert(message: error.localizedDescription)
            } else {
              User.currentUser?.address = self.addressSelected
              self.dismiss(animated: true)
            }
          }
        })
      }
    } else {
      delegate?.addressSent(addressSelected!)
      dismiss(animated: true)
    }
  }
}

extension SetAddressController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return false
  }
}



extension SetAddressController: GMSMapViewDelegate {
  
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    geocoder.reverseGeocodeCoordinate(lastPositionMoved) { (response, error) in
      if let error = error {
        self.showErrorAlert(message: error.localizedDescription)
      } else {
        if let addressLine = response?.firstResult()?.lines?.joined(separator: ", ") {
          DispatchQueue.main.async {
            self.addressLabel.text = addressLine
          }
        } else {
          DispatchQueue.main.async {
            self.addressLabel.text = "Address not found for this location."
          }
        }
      }
    }
  }
  
  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    lastPositionMoved = mapView.camera.target
    print("didChange")
  }
  
  func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
    print("didEndDragging")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ReachibilityManager.shared.addListener(listener: self)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    ReachibilityManager.shared.removeListener(listener: self)
  }
  
}


extension SetAddressController: NetworkStatusListener {
  func networkStatusDidChange(status: PlowdrNetworkStatus) {
    switch status {
    case .notReachable:
      break
    case .reachable:
      break
    }
  }
}


























