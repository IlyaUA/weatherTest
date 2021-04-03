//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 02.04.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var presenter: MapViewPresenterProtocol!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Long Press For Choose"
        setLongPressGesture()
    }
    
    private func setLongPressGesture() -> Void {
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPinOnMap(press:)))
        longPressGesture.minimumPressDuration = 0.3
        mapView.showsUserLocation = true
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func addPinOnMap(press : UILongPressGestureRecognizer) {
        
        if press.state == .ended {
            let point = press.location(in: self.mapView)
            let coordinates = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = coordinates
            self.mapView.addAnnotation(pointAnnotation)
            presenter.showSelectedCity(coordinate: pointAnnotation.coordinate) { AlertAction in
                switch AlertAction {
                case .cancel:
                    self.mapView.removeAnnotation(pointAnnotation)
                case .confirm:
                    self.mapView.addAnnotation(pointAnnotation)
                }
            }
        }
    }
}


extension MapViewController: MapViewProtocol {
    func showSelectedPlace(title: String, message: String, actions: [(title: String, action: () -> Void)]?) {
        let viewController = self
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: .default) { _ in
                    action.action()
                }
                alert.addAction(alertAction)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
}
