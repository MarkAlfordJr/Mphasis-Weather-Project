//
//  EndpointProtocol.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation

// https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={Api Key}
protocol Endpoint {
    var scheme: Scheme {get}
    var host: String {get}
    var path: String {get}
    var params: [URLQueryItem] {get}
    var method: RequestMethod {get}
    var headers: [String: String]? {get}
    var body: [String: String]? {get}
}

enum Scheme: String {
    case http = "HTTP"
    case https = "HTTPS"
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

extension Endpoint {
    var scheme: String {
        return Scheme.https.rawValue
    }
}
