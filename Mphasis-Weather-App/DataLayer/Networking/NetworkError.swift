//
//  NetworkError.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation

/// error enum used within the `NetworkManager` generic func, to document which errors are happening.
enum NetworkError: Error {
    case decodingError
    case invalidUrl
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decodingError:
            return "Error in decoding JSON"
        case .unauthorized:
            return "Networking Session Expired"
        default:
            return "Unknown Error"
        }
    }
}
