//
//  LocationClient.swift
//  WeatherApp1
//
//  Created by Colin Smith on 8/4/22.
//

import Foundation
import CoreLocation


@available(iOS 14.0, *)
public class LocationClient: NSObject, CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager?
    
    public var velocity: Double = 0.0
    
    public func checkLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled(), locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    
    public func getLocation() -> String? {
        guard let location = locationManager?.location?.coordinate else { return nil }
        let lat = String(describing: location.latitude)
        let long = String(describing:location.longitude)
        return lat+","+long
    }
    
    public func checkLocationAuthorization() {
         guard let locationManager = locationManager else {
             return
         }
         
         switch locationManager.authorizationStatus {
         case .authorizedAlways, .authorizedWhenInUse:
             break // We're good to go, don't need to check anything else
         case .denied, .restricted:
             //show alert about needing location
             print("You need to enable location services for this app to work")
         case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
         default :
             print(locationManager.authorizationStatus)
         }
         
     }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last  {
            self.velocity = lastLocation.speed.magnitude
        }
    }
}
