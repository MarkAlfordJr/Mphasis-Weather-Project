//
//  WeatherEndpoint.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation

/// enum to handle the different URL combinations, depending on the API call requirements
// https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={Api Key}
enum WeatherEndpoint {
    case getWeatherByCoord(lat: String, lon: String)
}

/// the properties inherited from the endpoint protocol will give out different values, depending on the enum's cases. This allows robust customization of the URL
extension WeatherEndpoint: Endpoint {
    
    var scheme: Scheme {
        switch self {
        case .getWeatherByCoord:
            return .https
        }
    }
    
    var host: String {
        switch self {
        case .getWeatherByCoord:
            return "api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .getWeatherByCoord:
            return "/data/2.5/weather"
        }
    }
    
    
    var params: [URLQueryItem] {
        switch self {
        case .getWeatherByCoord(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                // be sure to provide your own APIkey to run the app
                URLQueryItem(name: "appid", value: "enter your own API key")
            ]
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getWeatherByCoord:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var body: [String : String]? {
        switch self {
        case .getWeatherByCoord:
            return nil
        }
    }
}
