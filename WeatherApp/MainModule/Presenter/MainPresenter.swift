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


protocol MainViewProtocol: class {
    func updateUI(with currentWeather: Current?, place: GMSPlace?)
    func failure(failure: Error)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, locationService: LocationServiceProtocol)
    func getWeatherCurrentPlace()
    func getWeather(place: GMSPlace?)
    func loadCurrentWeatherImage(imageView: UIImageView)
    var weather: Weather? { get set }
}


class MainPresenter: MainViewPresenterProtocol {
  
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol
    var weather: Weather?
    let locationService: LocationServiceProtocol
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, locationService: LocationServiceProtocol) {
        self.view = view
        self.networkService = networkService
        self.locationService = locationService
        getWeatherCurrentPlace()
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
        if place?.coordinate != nil {
            networkService.getWeather(coordinates: (place?.coordinate)!) { [weak self] result in
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
        DispatchQueue.global(qos: .background).async { [self] in
            let url = URL(string: "http://openweathermap.org/img/wn/\(weather?.currentWeather.weather[0].icon ?? "")@2x.png")
            DispatchQueue.main.async {
                imageView.kf.setImage(with: url)
            }
        }
    }
}
