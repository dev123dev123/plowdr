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
    
//    setMapView()
    
    addressMapView.delegate = self
    
//    addressTextView.delegate = self
    
    
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
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: camera.target.latitude, longitude: camera.target.latitude)
        marker.title = "Center"
        marker.map = self.addressMapView
        
        self.addressSelected = Address(
          addressLine: "",
          city: "",
          state: "",
          postalCode: "",
          country: "",
          latitude: camera.target.latitude,
          longitude: camera.target.latitude
        )
    }
  }
  
  func setMapView() {
    let latitude = -33.86
    let longitude = 151.20
    
    let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
    addressMapView.camera = camera
    
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    marker.title = "Your Address"
    marker.map = addressMapView
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
      longitude: lastPositionMoved.latitude
    )
    
    delegate?.addressSent(addressSelected!)
    
    dismiss(animated: true)
  }
  
  func showGooglePlacesViewController() {
    let autocompleteController = GMSAutocompleteViewController()
    autocompleteController.delegate = self
    
    let addressFilter = GMSAutocompleteFilter()
//    addressFilter.type = .geocode

    autocompleteController.autocompleteFilter = addressFilter
    
    present(autocompleteController, animated: true)
  }
  
}

extension SetAddressController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    showGooglePlacesViewController()
    return false
  }
  
}

extension SetAddressController:  GMSAutocompleteViewControllerDelegate {
  
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    if let addressLines = place.addressComponents {
      for field in addressLines {
        switch field.type {
        case kGMSPlaceTypeStreetNumber:
          streetNumber = field.name
        case kGMSPlaceTypeRoute:
          route = field.name
        case kGMSPlaceTypeNeighborhood:
          neighborhood = field.name
        case kGMSPlaceTypeLocality:
          locality = field.name
        case kGMSPlaceTypeAdministrativeAreaLevel1:
          administrativeAreaLevel1 = field.name
        case kGMSPlaceTypeCountry:
          country = field.name
        case kGMSPlaceTypePostalCode:
          postalCode = field.name
        case kGMSPlaceTypePostalCodeSuffix:
          postalCodeSuffix = field.name
        default:
          break
        }
      }
    }
    
    
    
    var pCode = ""
    
    if postalCodeSuffix != "" {
      pCode = "\(postalCode) - \(postalCodeSuffix)"
    } else {
      pCode = "\(postalCode)"
    }
    
    addressSelected = Address(
      addressLine: "\(streetNumber) \(route)",
      city: locality,
      state: administrativeAreaLevel1,
      postalCode: pCode,
      country: country,
      latitude: place.coordinate.latitude,
      longitude: place.coordinate.longitude
    )
    
//    addressTextView.text = addressSelected?.description
    
    addressMapView.clear()
    
    dismiss(animated: true)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    showErrorAlert(message: error.localizedDescription)
  }

  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true)
  }
}



extension SetAddressController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    lastPositionMoved = mapView.camera.target
  }
}





























