//
//  WeatherService.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation

/// protocol used for dependency injection, at a later date
protocol WeatherServiceProtocol {
    func getWeather(latitude: String, longitude: String) async -> Result<WeatherResponseModel, NetworkError>
}

struct WeatherService: NetworkingManagerProtocol, WeatherServiceProtocol {
    /**
     Main func to call the GENERIC api request func. this will use the custom Endpoint enum to fill up the generic func's parameters
     - Parameters:
        - latitude: String coordinates from the Geocoding API, converted from the user's input
        - longitude: String coordinates from the Geocoding API, converted from the user's input
     - Returns: the `Result` completion handler, needed to handle to the JSON data being decoded
     */
    func getWeather(latitude: String, longitude: String) async -> Result<WeatherResponseModel, NetworkError> {
        return await sendRequest(endpoint: WeatherEndpoint.getWeatherByCoord(lat: latitude, lon: longitude), responseModel: WeatherResponseModel.self)
    }
}
