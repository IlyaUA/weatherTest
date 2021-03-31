//
//  Person.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Float
    let current: Current
    let minutely: [Minutely]
    let hourly: [Current]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, minutely, hourly, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Double
    let sunrise, sunset: Float?
    let temp, feelsLike: Double
    let pressure, humidity: Float
    let dewPoint, uvi: Double
    let clouds, visibility: Float
    let windSpeed: Double
    let windDeg: Float
    let weather: [WeatherElement]
    let windGust: Double?
    let pop: Float?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop
    }
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Float
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Float
    let dewPoint, windSpeed: Double
    let windDeg: Float
    let weather: [WeatherElement]
    let clouds, pop: Float
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, pop, uvi
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

// MARK: - Minutely
struct Minutely: Codable {
    let dt, precipitation: Float
}
