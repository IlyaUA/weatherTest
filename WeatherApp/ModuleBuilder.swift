//
//  ModuleBuilder.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let locationService = LocationService()
        let presenter = MainPresenter(view: view, networkService: networkService, locationService: locationService)
        view.presenter = presenter
        return view
    }
}
