//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    static var identifier = "hourlyCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupHourlyWeather(hourlyWeather: Current) {
        temperature.text = String(format: "%.0f", (hourlyWeather.temp ) - 273.15) + "°"
        hour.text = TimestampConverter.getFormatedDate(format: "HH:mm", timestamp: hourlyWeather.dt )
        if let iconName = hourlyWeather.weather.first?.icon {
            let url = URL(string: "http://openweathermap.org/img/wn/\(iconName)@2x.png")
            weatherImage.kf.setImage(with: url)
        }
    }
    
}
