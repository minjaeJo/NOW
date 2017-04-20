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
    
    var locationStart = CLLocation()
    var locationDestination = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //locationManager - 좌표 알려주는 매니져
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //googleMapsView - 지도 생성 및 표시
        let camera = GMSCameraPosition.camera(withLatitude: 37.405614, longitude: 127.106064, zoom: 15.0)
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
    
// Part - Delegate : Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get lotation \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        //let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 16.0)
        
        let locationTujuan = CLLocation(latitude: 38.083229, longitude: -122.011622)
        
        createMarker(titleMarker: "1", iconMarker: #imageLiteral(resourceName: "DPin") , latitude: locationTujuan.coordinate.latitude , longitude: locationTujuan.coordinate.longitude)
        
        createMarker(titleMarker: "2", iconMarker: #imageLiteral(resourceName: "SPin") , latitude: (location?.coordinate.latitude)! , longitude:
            (location?.coordinate.longitude)!)
        
        drawPath(startLocation: locationTujuan, endLocation: location!)
        //self.googleMaps?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
// Part - Delegate : GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }
        // 내가 해당 좌표를 누를 때마다 좌표값 표시
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("coordinate = \(coordinate)")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
// Part - Method : 출발지와 도착지의 경로를 생성하는 기능 - Directions API
    func drawPath(startLocation: CLLocation, endLocation : CLLocation ) {
        let origin = "\(startLocation.coordinate.latitude), \(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude), \(startLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)4&mode=walking "
        
        Alamofire.request(url).responseJSON{ response in
            print(response.request as Any)
            print(response.response as Any)
            print(response.data as Any)
            print(response.result as Any)
            
            let json = JSON(data: response.data!)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    




}
