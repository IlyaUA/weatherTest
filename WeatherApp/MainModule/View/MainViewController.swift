//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import UIKit
import Kingfisher
import GooglePlaces
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var wet: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var locationButton: UIButton!
    
    
    var presenter: MainViewPresenterProtocol!
    //var locationManager: CLLocationManager?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        presenter.checkLocationFromMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupUI
        let nibName = UINib(nibName: DailyWeatherTableViewCell.className, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        
        let customCellNib = UINib(nibName: HourlyCollectionViewCell.className, bundle: .main)
        collectionView.register(customCellNib, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        
        if let image = UIImage(named: "pin1") {
            locationButton.leftImage(image: image)
        }
       
    }
    
    func setupWeatherImage(image: UIImage) {
        weatherImage.image = image
    }
    
    
    @IBAction func chooseCity(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
         
    }
    
    @IBAction func openMapButtonAction(_ sender: Any) {
        presenter.openMap()
    }
    
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.weather?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as! DailyWeatherTableViewCell
        if let dayWeather = presenter.weather?.daily[indexPath.row] {
        cell.setupWeather(with: dayWeather)
        }
        return cell
    }
    
}
// TODO temp formatter, + module for search + location
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.weather?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        if let hourlyWeather = presenter.weather?.hourly[indexPath.row] {
            cell.setupHourlyWeather(hourlyWeather: hourlyWeather)
        }
        
        return cell
    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 110)
    }
}

extension MainViewController: MainViewProtocol {
        
    func updateUI(with currentWeather: Current?, place: GMSPlace?) {
        if (currentWeather != nil) {
            presenter.loadCurrentWeatherImage(imageView: weatherImage)
            date.text = TimestampConverter.getFormatedDate(format: "E, d MMM", timestamp: currentWeather?.dt)
            temperature.text = String(format: "%.0f", (currentWeather?.temp ?? 273.15) - 273.15) + "°"
            wet.text = String(currentWeather?.humidity ?? 0) + "%"
            wind.text = String(currentWeather?.windSpeed ?? 0) + "м/с"
            if let placeName = place?.name {
                locationButton.setTitle(placeName, for: .normal)
            } else if let mapPlaceName = LocationModel.sharedInstance.city {
                locationButton.setTitle(mapPlaceName, for: .normal)
            }
            
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    func failure(failure: Error) {
        print(failure.localizedDescription)
    }
}

extension MainViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        presenter.getWeather(place: place)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
