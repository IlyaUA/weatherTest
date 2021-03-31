//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func getWeather(completion: @escaping (Result<Weather?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func getWeather(completion: @escaping (Result<Weather?, Error>) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=47.858689&lon=35.110882&exclude=alerts&appid=790e0af58858871d1b07665bd226d09d&lang=ru"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString {
                response in
                switch response.result{
                case .failure (let error):
                    completion(.failure(error))
                case .success:
                    do{
                        let weather = try JSONDecoder().decode(Weather.self, from: Data(response.value!.utf8))
                        completion(.success(weather))
                    } catch (let exception) {
                        completion(.failure(exception))
                    }
                   
                }
        }
    }
    
    
}
