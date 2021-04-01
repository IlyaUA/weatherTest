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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        let nibName = UINib(nibName: DailyWeatherTableViewCell.className, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        
        let customCellNib = UINib(nibName: HourlyCollectionViewCell.className, bundle: .main)
        collectionView.register(customCellNib, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        
        locationButton.leftImage(image: UIImage(named: "pin1")!)
    }
    
    
    @IBAction func chooseCity(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.weather?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DailyWeatherTableViewCell
        let dayWeather = presenter.weather?.daily[indexPath.row]
        cell.temperature.text = String(format: "%.0f", (dayWeather?.temp.day ?? 273.15) - 273.15) + "°" + "/" + String(format: "%.0f", (dayWeather?.temp.night ?? 273.15) - 273.15) + "°"
        cell.dayOfWeek.text = TimestampConverter.getDayOfWeek(timestamp: (dayWeather?.dt)!)
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "http://openweathermap.org/img/wn/\(dayWeather?.weather[0].icon ?? "")@2x.png")
            DispatchQueue.main.async {
                cell.weatherImage.kf.setImage(with: url)
            }
        }
        return cell
    }
    
}
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as! HourlyCollectionViewCell
        let hourlyWeather = presenter.weather?.hourly[indexPath.row]
        cell.temperature.text = String(format: "%.0f", (hourlyWeather?.temp ?? 273.15) - 273.15) + "°"
        cell.hour.text = TimestampConverter.getFormatedDate(format: "HH:mm", timestamp: hourlyWeather?.dt ?? nil)
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "http://openweathermap.org/img/wn/\(hourlyWeather?.weather[0].icon ?? "777")@2x.png")
            DispatchQueue.main.async {
                cell.weatherImage.kf.setImage(with: url)
            }
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
            locationButton.setTitle(place?.name, for: .normal)
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
