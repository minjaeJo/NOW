//
//  SecondViewController.swift
//  now
//
//  Created by   minjae on 2017. 4. 16..
//  Copyright © 2017년 minjae. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

enum Location {
    case startLocation
    case destinationLocation
}

class MapViewController: UIViewController,GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMaps: GMSMapView!
    
    // CLLocation은 좌표(위도, 경도)를 알려주는 데이터 오브젝트
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    

    var locationArray = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //locationManager - 좌표 알려주는 매니져
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //googleMapsView - 지도 생성 및 표시18.471522, -69.940598
        let camera = GMSCameraPosition.camera(withLatitude: 18.471522, longitude: -69.940598, zoom: 15.0)
        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps?.isMyLocationEnabled = true
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.settings.zoomGestures = true
    }
    
// Part - Method : 맵에 마커 생성하는 기능
    func createMarker(titleMarker : String, iconMarker: UIImage, latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
    }
    
// Part - Delegate : GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }
    
    // 내가 해당 좌표를 누를 때마다 좌표값 표시
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        locationArray.append(coordinate)
        if locationArray.count == 3 {
            locationArray.remove(at: 0)
        }
        print("coordinate = \(coordinate.latitude),\(coordinate.longitude)")
        
    }
    
// Part - Method : 출발지와 도착지의 경로를 생성하는 기능 - Directions API
    func drawPath(startLocation: CLLocationCoordinate2D, endLocation : CLLocationCoordinate2D ) {
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(startLocation.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&way=walking"
        
        Alamofire.request(url).responseJSON{ responds in
            print(responds.request as Any)
            print(responds.response as Any)
            print(responds.data as Any)
            print(responds.result as Any)
            
            let json = JSON(data: responds.data!)
            let routes = json["routes"].arrayValue
            
            // 출발점과 도착점을 polyline으로 연결하기
            for route in routes {
                let routeOverViewPolyine = route["overview_polyline"].dictionary
                let points = routeOverViewPolyine?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeColor = UIColor.red
                polyline.strokeWidth = 4
                polyline.map = self.googleMaps
            }
        }
    }

    @IBAction func showDirection(_ sender: Any) {
        let startLocation = locationArray[0]
        let destinationLocation = locationArray[1]

        self.googleMaps.clear()
        self.drawPath(startLocation: startLocation, endLocation: destinationLocation)
        createMarker(titleMarker: "출발점", iconMarker: #imageLiteral(resourceName: "startPin"), latitude: startLocation.latitude, longitude: startLocation.longitude)
//        createMarker(titleMarker: "도착점", iconMarker: #imageLiteral(resourceName: "endPin"), latitude: destinationLocation.latitude, longitude: destinationLocation.longitude)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    




}
