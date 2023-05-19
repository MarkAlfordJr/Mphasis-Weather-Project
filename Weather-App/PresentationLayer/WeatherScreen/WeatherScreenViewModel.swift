//
//  WeatherScreenViewModel.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation
import UIKit

class WeatherScreenViewModel {
    //MARK: properties
    private var weatherService: WeatherServiceProtocol
    // used for updating the UI with JSON
    var updateUI: ((_ newDataToDisplay: WeatherResponseModel) -> Void)?
    
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    var geoLocManager = GeolocationManager()
    
    /**
     Function that converts the user's string into coordinates to be used in the actual API call. calls the conversion func, then with a completionhandler, FINALLY makes the request with the `getWeather` func below
     - Parameters:
        - addressString: the search bar text
     */
    func convertAddresstoCoordinates(by addressString: String) {
        geoLocManager.forwardGeocoding(address: addressString)
        geoLocManager.updateUI = { [weak self] coordinate in
            // coordinate is a tuple
            self?.getWeather(withAddress: coordinate)
        }
    }
    
    /**
     Function that makes the API call
     - Parameters:
        - withAddress: a tuple, used to represent both the coordinates from the converted string value, within the searchBar
     */
    func getWeather(withAddress: (Double, Double)) {
        Task(priority: .background) {
            let result = await weatherService.getWeather(latitude: String(withAddress.0), longitude: String(withAddress.1))
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    print("response JSON \n\(weatherResponse)")
                    self.updateUI?(weatherResponse)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
