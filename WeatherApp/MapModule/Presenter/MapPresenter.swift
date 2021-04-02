//
//  MapPresenter.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 02.04.2021.
//

import Foundation
import MapKit
import CoreLocation
import UIKit

enum AlertAction {
    case cancel
    case confirm
}

protocol MapViewProtocol: class {
    func confirmSelectedLocation(title: String, message: String, actions: [(title: String, action: () -> Void)]?)
}

protocol MapViewPresenterProtocol: class {
    init(view: MapViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    var locationModel: LocationModel? { get set }
    func confirmAddingCity(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (AlertAction) -> Void)
    func saveCity(location: LocationModel) -> Void
}

class MapViewPresenter: MapViewPresenterProtocol {
   
    weak var view: MapViewProtocol?
    var locationModel: LocationModel?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol
    
    required init(view: MapViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
        
    // Show Alert to confirm or cancel adding city to bookmark
    func confirmAddingCity(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (AlertAction) -> Void) {
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [unowned self] (placemarks, error) in
            if error != nil {
                self.view?.confirmSelectedLocation(title: "Something went wrong", message: error!.localizedDescription, actions: nil)
            } else {
                let placemark = placemarks?.first
            
                if let cityName = placemark?.administrativeArea , let countryName = placemark?.country {
                    
                    self.view?.confirmSelectedLocation(title: cityName + ", " + countryName, message: "Show weather by this city?", actions: [(title:"Cancel",action: {
                        completionHandler(.cancel)
                    })
                        , (title:"Ok", action: {
                            completionHandler(.confirm)
                            
                            let location = LocationModel.sharedInstance
                            location.city = cityName
                            location.latitude = coordinate.latitude
                            location.longitude = coordinate.longitude
                            location.presented = false
                            router?.popToRoot()
                        })])
                }
                else {
                    self.view?.confirmSelectedLocation(title: "Sorry", message: "Unable to identify location Press on correct location.", actions:[(title:"Ok",action: {
                        completionHandler(.cancel)
                    })])
                }
            }
        })
    }
    
    func saveCity(location: LocationModel) -> Void {
//        let selectedLocation = LocationWeather.sharedInstance.weather
//        selectedLocation?.city = location.city
//        selectedLocation?.latitude = location.latitude
//        selectedLocation?.longitude = location.longitude
    }
    
}

