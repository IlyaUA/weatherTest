//
//  ClassNameExtension.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 01.04.2021.
//

import Foundation


extension NSObject {
  static var className: String {
    return String(describing: self)
  }
}
