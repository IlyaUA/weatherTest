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
    func showSelectedPlace(title: String, message: String, actions: [(title: String, action: () -> Void)]?)
}

protocol MapViewPresenterProtocol: class {
    init(view: MapViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    var locationModel: LocationModel? { get set }
    func showSelectedCity(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (AlertAction) -> Void)
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
    
    func showSelectedCity(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (AlertAction) -> Void) {
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [unowned self] (placemarks, error) in
            if error != nil {
                self.view?.showSelectedPlace(title: "Something went wrong", message: error!.localizedDescription, actions: nil)
            } else {
                let placemark = placemarks?.first
                
                if let cityName = placemark?.administrativeArea , let countryName = placemark?.country {
                    
                    self.view?.showSelectedPlace(title: cityName + ", " + countryName, message: "Show the weather in this city?", actions: [(title:"Cancel",action: {
                        completionHandler(.cancel)
                    })
                    , (title:"OK", action: {
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
                    self.view?.showSelectedPlace(title: "Error", message: "Failed to recognize the location, try another.", actions:[(title:"OK",action: {
                        completionHandler(.cancel)
                    })])
                }
            }
        })
    }
}

