//
//  LocationService.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 01.04.2021.
//

import UIKit
import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func getCurrentLocation() -> CLLocation?
    func checkServiceStatus () -> Bool
    func startUpdatingLocation()
}

class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {

    fileprivate let locationManager = CLLocationManager()
    var location: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() { // Start updating called from presenter
        locationManager.startUpdatingLocation()
    }

    func getCurrentLocation() -> CLLocation? {
        return location
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.horizontalAccuracy > 0 {
                locationManager.stopUpdatingLocation()
                self.location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude)
            }
        }
    }
    
    func checkServiceStatus () -> Bool {
        var statusChecker = false
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            statusChecker = false
        case .authorizedAlways, .authorizedWhenInUse:
            statusChecker = true
        @unknown default:
            statusChecker = false
            break
        }
        return statusChecker
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
    }
    
}
