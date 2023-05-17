//
//  WeatherEndpoint.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation

// https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=f5d41321cdb9903ae018ae5864d86432
enum WeatherEndpoint {
    case getWeatherByCoord(lat: String, lon: String)
}

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
                URLQueryItem(name: "appid", value: Constants.appID)
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
