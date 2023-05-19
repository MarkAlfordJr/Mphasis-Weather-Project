//
//  NetworkManager.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation

/// protocol needed for dependency injection, at a later date
protocol NetworkingManagerProtocol {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, NetworkError>
}

extension NetworkingManagerProtocol {
    /**
     the GENERIC api request func. this will be used by all future API services.
     - Parameters:
        - endpoint: the specific Endpoint enums along with their cases. This will construct the URLComponent(), depending on the case
        - responseModel: the specific `Codable` data model needed to parse the JSON from the unique API requests
     - Returns: a generic `Result` completion handler, needed to handle to the JSON data being decoded
     */
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, NetworkError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.params
        
        guard let url = urlComponents.url else {
            return .failure(.invalidUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            /// depending on the status code, an error from the `NetworkError` enum will be used
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decodingError)
                }
                print("should be response: \(decodedResponse)")
                return.success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
