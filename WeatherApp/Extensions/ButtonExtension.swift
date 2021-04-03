//
//  ButttonExtension.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import UIKit

extension UIButton {

  func leftImage(image: UIImage) {
    self.setImage(image, for: .normal)
    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width)
  }
}
