//
//  DailyWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    static var identifier = "dailyCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWeather (with dailyWeather: Daily) {
        temperature.text = String(format: "%.0f", (dailyWeather.temp.day ) - 273.15) + "°" + "/" + String(format: "%.0f", (dailyWeather.temp.night ) - 273.15) + "°"
        dayOfWeek.text = TimestampConverter.getDayOfWeek(timestamp: (dailyWeather.dt))
        if let iconName = dailyWeather.weather.first?.icon {
            let url = URL(string: "http://openweathermap.org/img/wn/\(iconName)@2x.png")
            weatherImage.kf.setImage(with: url)
        }
    }
}
