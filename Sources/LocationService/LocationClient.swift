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
    public var streetAddress: String = ""
    public func checkLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled(), locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.startUpdatingLocation()
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    public func getLocation() -> String? {
        guard let location = locationManager?.location else { return nil }
        return String(describing: location.coordinate.latitude) + "," + String(describing: location.coordinate.longitude)
    }
    
    public func getStreetAddress() async -> String {
        let geocoder = CLGeocoder()
        guard let location = locationManager?.location else {
            checkLocationAuthorization()
            return "Not getting location asynchronously"
        }
        var returnStringForAddress = ""
        do {
            try await returnStringForAddress = geocoder.reverseGeocodeLocation(location).first?.name! ?? "Reverse Geocode Error"
        } catch {
            //handling errors here
            print("error here")
        }
       
        return returnStringForAddress
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
