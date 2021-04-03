//
//  UIViewController.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 03.04.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, style: UIAlertAction.Style, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: buttonTitle, style: style, handler: nil)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
    }
}

