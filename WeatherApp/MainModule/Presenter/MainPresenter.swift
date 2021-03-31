//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import Foundation

protocol MainViewProtocol: class {
    func success()
    func failure(failure: Error)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol)
    func getWeather()
    var weather: Weather? { get set }
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol
    var weather: Weather?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getWeather()
    }
    
    
    
    func getWeather() {
        
        networkService.getWeather { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weather = weather
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(failure: error)
                }
            }
        }
    }
}
