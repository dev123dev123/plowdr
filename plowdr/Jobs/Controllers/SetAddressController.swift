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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setMapView()
    
    addressTextView.delegate = self
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
    
    addressTextView.text = addressSelected?.description
    
    addressMapView.clear()
    
    let latitude = place.coordinate.latitude
    let longitude = place.coordinate.longitude
    
    let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
    
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    marker.title = "Your Address"
    marker.map = addressMapView
    
    addressMapView.camera = camera
    
    dismiss(animated: true)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    showErrorAlert(message: error.localizedDescription)
  }

  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true)
  }
}






























