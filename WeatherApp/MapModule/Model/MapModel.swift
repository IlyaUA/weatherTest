//
//  MapModel.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 02.04.2021.
//

import Foundation

class LocationModel {
    
    static let sharedInstance = LocationModel()
    
    var city : String?
    var latitude : Double?
    var longitude : Double?
    var presented: Bool?
    
}
