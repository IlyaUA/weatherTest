//
//  Router.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 02.04.2021.
//

import Foundation
import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showMapController()
    func popToRoot()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.assemblyBuilder = assemblyBuilder
        self.navigationController = navigationController
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.navigationBar.isHidden = true
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showMapController() {
        if let navigationController = navigationController {
            guard let mapViewController = assemblyBuilder?.createMapModule(router: self) else { return }
            navigationController.navigationBar.isHidden = false
            navigationController.pushViewController(mapViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.navigationBar.isHidden = true
            navigationController.popToRootViewController(animated: true)
        }
    }
}
