//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import UIKit
import Kingfisher

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
    let timeConverter = TimestampConverter.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "DailyWeatherTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "dailyCell")
        
        let customCellNib = UINib(nibName: "HourlyCollectionViewCell", bundle: .main)
        collectionView.register(customCellNib, forCellWithReuseIdentifier: "hourlyCell")
        
        locationButton.leftImage(image: UIImage(named: "pin1")!)
    }
    
    
    @IBAction func chooseCity(_ sender: Any) {
    }
    
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.weather?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DailyWeatherTableViewCell
        let dayWeather = presenter.weather?.daily[indexPath.row]
        cell.temperature.text = String(format: "%.0f", (dayWeather?.temp.day ?? 0) / 32) + "°" + "/" + String(format: "%.0f", (dayWeather?.temp.night ?? 0) / 32) + "°"
        cell.dayOfWeek.text = timeConverter.getDayOfWeek(timestamp: (dayWeather?.dt)!)
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
        cell.temperature.text = String(format: "%.0f", (hourlyWeather?.temp ?? 0) / 32) + "°"
        cell.hour.text = timeConverter.getTime(timestamp: hourlyWeather?.dt ?? nil)
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
    
    func success() {
        tableView.reloadData()
        collectionView.reloadData()
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "http://openweathermap.org/img/wn/\(self.presenter.weather?.current.weather[0].icon ?? "777")@2x.png")
            DispatchQueue.main.async {
                self.weatherImage.kf.setImage(with: url)
            }
        }
        self.date.text = timeConverter.test(format: "E, d MMM", timestamp: self.presenter.weather?.current.dt)
        self.temperature.text = String(format: "%.0f", (presenter.weather?.current.temp ?? 0) / 32) + "°"
        self.wet.text = String(presenter.weather?.current.humidity ?? 0) + "%"
        self.wind.text = String(presenter.weather?.current.windSpeed ?? 0) + "м/с"
    }
    
    func failure(failure: Error) {
        print(failure.localizedDescription)
    }
    
}
