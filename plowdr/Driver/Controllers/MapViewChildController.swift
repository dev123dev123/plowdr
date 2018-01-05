//
//  MapViewChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/29/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewChildController: UIViewController {
  @IBOutlet weak var mapView: GMSMapView!
  
  var currentTask: Task!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let camera = GMSCameraPosition.camera(
      withLatitude: currentTask.latitude,
      longitude: currentTask.longitude,
      zoom: 15.0)
    self.mapView.camera = camera
    
    let markerImage = UIImage(named: "map-marker")!.withRenderingMode(.alwaysTemplate)
    let markerView = UIImageView(image: markerImage)
    markerView.tintColor = UIColor.black
    
    let position = CLLocationCoordinate2D(latitude: currentTask.latitude, longitude: currentTask.longitude)
    
    let marker = GMSMarker(position: position)
    marker.title = currentTask.clientName
    marker.map = self.mapView
    marker.iconView = markerView
    
    mapView.selectedMarker = marker
  }
}




































