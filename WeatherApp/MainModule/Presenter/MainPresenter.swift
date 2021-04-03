//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import Foundation
import UIKit
import GooglePlaces
import CoreLocation
import Kingfisher

protocol LocationAuthorizationChangeDelegate {
    func authorizationChangeHandler(state: Bool)
}

protocol MainViewProtocol: class {
    func updateUI(with currentWeather: Current?, place: GMSPlace?)
    func failure(failure: Error)
    func setupWeatherImage(image: UIImage)
    func locationAuthDenied()
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, locationService: LocationServiceProtocol, router: RouterProtocol)
    func getWeatherCurrentPlace()
    func getWeather(place: GMSPlace?)
    func openMap()
    func loadCurrentWeatherImage(imageView: UIImageView)
    func checkLocationFromMap()
    var weather: Weather? { get set }
}


class MainPresenter: MainViewPresenterProtocol, LocationAuthorizationChangeDelegate {
    func authorizationChangeHandler(state: Bool) {
        if state == true {
            getWeatherCurrentPlace()
        } else {
            self.view?.locationAuthDenied()
            locationFromMap.city = "Zaporizhzhia"
            locationFromMap.latitude = 47.845546
            locationFromMap.longitude = 35.130028
            locationFromMap.presented = false
            getWeather(place: nil)
        }
    }
    
   
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol
    var router: RouterProtocol?
    var weather: Weather?
    var locationService: LocationServiceProtocol
    let locationFromMap = LocationModel.sharedInstance
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, locationService: LocationServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.locationService = locationService
        self.router = router
        self.locationService.locationAuthorizationDelegate = self
    }
    
    func getWeatherCurrentPlace() {
        networkService.getCurrentCity { [weak self] item in
            switch item {
            case .success(let place):
                self?.getWeather(place: place)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getWeather(place: GMSPlace?) {
        var coordinate: CLLocationCoordinate2D?
        if place?.coordinate != nil {
            coordinate = place!.coordinate
        } else if locationFromMap.latitude != nil && locationFromMap.longitude != nil {
            coordinate = CLLocationCoordinate2D(latitude: locationFromMap.latitude!, longitude: locationFromMap.longitude!)
            locationFromMap.presented = true
        }
        
        if let coordinate = coordinate {
            networkService.getWeather(coordinates: coordinate) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        self.weather = weather
                        self.view?.updateUI(with: weather?.currentWeather ?? nil, place: place)
                    case .failure(let error):
                        self.view?.failure(failure: error)
                    }
                }
            }
        }
    }
    
    func loadCurrentWeatherImage(imageView: UIImageView) {
        guard let iconName = weather?.currentWeather.weather.first?.icon,
        let url = URL(string: "http://openweathermap.org/img/wn/\(iconName)@2x.png")
        else { return }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            let image = try? result.get().image
            if let image = image {
                self?.view?.setupWeatherImage(image: image)
            }
        }
    }
    
    func openMap() {
        router?.showMapController()
    }
    
    func checkLocationFromMap() {
        if locationFromMap.presented != nil && locationFromMap.presented == false {
            self.getWeather(place: nil)
        }
    }
    
    
 
}
