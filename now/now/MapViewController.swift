//
//  SecondViewController.swift
//  now
//
//  Created by   minjae on 2017. 4. 16..
//  Copyright © 2017년 minjae. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController,GMSMapViewDelegate {
    
    var mapView : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지도 생성 및 표시
        let camera = GMSCameraPosition.camera(withLatitude: 37.405614, longitude: 127.106064, zoom: 15.0)
        let viewSize = CGRect(x: 0, y: 20, width: 375, height: 548)
        mapView = GMSMapView.map(withFrame: viewSize , camera: camera)
        self.view.addSubview(mapView!)
        
        // 현재위치 - 마커(핀) 표시
        let currentLocation = CLLocationCoordinate2D(latitude: 37.405614, longitude: 127.106064)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "스타트업캠퍼스"
        marker.snippet = "경기도 성남시 분당구 삼평동 대왕판교로289번길 20"
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.map = mapView
        
       
    }

//    override func loadView() {
//        mapView.mapType = kGMSTypeNormal
//        mapView.isIndoorEnabled = false
//        mapView.settings.compassButton = true
//        mapView.settings.myLocationButton = true
//        
//        mapView.settings.scrollGestures = true
//        mapView.settings.zoomGestures = true
//        mapView.isMyLocationEnabled = true
//        
//       
//        
//        // Creates a marker in the center of the map.
//        let position = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.127)
//        let london = GMSMarker(position: position)
//        london.title = "London 카페"
//        london.snippet = "런던 최고의 맛집"
//        london.icon = GMSMarker.markerImage(with: .black)
//        london.map = mapView
//        
//        let circleCenter = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.127)
//        let circ = GMSCircle(position: circleCenter, radius: 1000)
//        circ.fillColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.35)
//
//        circ.map = mapView
//    }
}
