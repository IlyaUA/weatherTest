//
//  ModuleBuilder.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createMapModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let locationService = LocationService()
        let presenter = MainPresenter(view: view, networkService: networkService, locationService: locationService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createMapModule(router: RouterProtocol) -> UIViewController {
        let view = MapViewController()
        let networkService = NetworkService()
        let presenter = MapViewPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
}
