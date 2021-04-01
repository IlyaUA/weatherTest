//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import Foundation
import Alamofire
import GooglePlaces

protocol NetworkServiceProtocol {
    func getWeather(coordinates: CLLocationCoordinate2D, completion: @escaping (Result<Weather?, Error>) -> Void)
    func getCurrentCity(completion: @escaping (Result<GMSPlace?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func getWeather(coordinates: CLLocationCoordinate2D, completion: @escaping (Result<Weather?, Error>) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&exclude=alerts&appid=790e0af58858871d1b07665bd226d09d&lang=ru"
        
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
    
    func getCurrentCity(completion: @escaping (Result<GMSPlace?, Error>) -> Void) {
        
        let placesClient = GMSPlacesClient()
        let placeFields: GMSPlaceField =  [.name, .formattedAddress, .coordinate]
        
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (placeLikelihoods, error) in
            guard self != nil else {
                return
            }
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let placeInfo = placeLikelihoods?.first?.place else { return }
            
            completion(.success(placeInfo))
            
        }
    }
    
    
}
