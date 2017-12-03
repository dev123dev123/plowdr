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

class SetAddressController: UIViewController {
  
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
  
  var lastPositionMoved = CLLocationCoordinate2D(latitude: 36.778259, longitude: -119.417931)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addressMapView.delegate = self
    

    if let addressSelected = addressSelected {
      print("""
        on viewDidLoad:
        latitude: \(addressSelected.latitude)
        longitude: \(addressSelected.longitude)
        """)
      
      let camera = GMSCameraPosition.camera(withLatitude: addressSelected.latitude, longitude: addressSelected.longitude, zoom: 15.0)
      self.addressMapView.camera = camera
    } else {
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
      addressLine: "",
      city: "",
      state: "",
      postalCode: "",
      country: "",
      latitude: lastPositionMoved.latitude,
      longitude: lastPositionMoved.longitude
    )
    
    print("""
      on saveLabelTapped:
      latitude: \(lastPositionMoved.latitude)
      longitude: \(lastPositionMoved.longitude)
    """)
    
    delegate?.addressSent(addressSelected!)
    
    dismiss(animated: true)
  }
}

extension SetAddressController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return false
  }
}

extension SetAddressController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    lastPositionMoved = mapView.camera.target
  }
}





























