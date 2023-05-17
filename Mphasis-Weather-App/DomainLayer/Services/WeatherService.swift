//
//  WeatherService.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeather(latitude: String, longitude: String) async -> Result<WeatherResponseModel, NetworkError>
}

struct WeatherService: NetworkingManagerProtocol, WeatherServiceProtocol {
    func getWeather(latitude: String, longitude: String) async -> Result<WeatherResponseModel, NetworkError> {
        return await sendRequest(endpoint: WeatherEndpoint.getWeatherByCoord(lat: latitude, lon: longitude), responseModel: WeatherResponseModel.self)
    }
}
