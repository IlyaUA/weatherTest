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
    func startUpdatingLocation()
    var locationAuthorizationDelegate: LocationAuthorizationChangeDelegate? { get set }
}

class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {

    fileprivate let locationManager = CLLocationManager()
    var location: CLLocation?
    var locationAuthorizationDelegate: LocationAuthorizationChangeDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() {
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            locationAuthorizationDelegate?.authorizationChangeHandler(state: true)
            break
        case .denied , .restricted:
            locationAuthorizationDelegate?.authorizationChangeHandler(state: false)
            break
        default:
            break
        }
    }
    
}
