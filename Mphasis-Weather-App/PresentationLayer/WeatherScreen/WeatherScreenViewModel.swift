//
//  WeatherScreenViewModel.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation
import UIKit

class WeatherScreenViewModel {
    private var weatherService: WeatherServiceProtocol
    var updateUI: ((_ newDataToDisplay: WeatherResponseModel) -> Void)?
    var weatherImgString = ""
    var tempFahrenheit =  ""
    var tempCelsuis = ""
    var cityName = ""
    var countryName = ""
    var descriptionText = ""
    
    init(weatherService: WeatherServiceProtocol = WeatherService(), weatherString: String = "", tempFahrenheit: String = "", tempCelsuis: String = "", cityName: String = "", countryName: String = "", descriptionText: String = "") {
        self.weatherService = weatherService
        self.weatherImgString = weatherString
        self.tempFahrenheit = tempFahrenheit
        self.tempCelsuis = tempCelsuis
        self.cityName = cityName
        self.countryName = countryName
        self.descriptionText = descriptionText
    }
    
    var geoLocManager = GeolocationManager()
    
    func convertAddresstoCoordinates(by addressString: String) {
        geoLocManager.forwardGeocoding(address: addressString)
        geoLocManager.updateUI = { [weak self] coordinate in
            // coordinate is a tuple
            self?.getWeather(withAddress: coordinate)
        }
    }
    
    func getWeather(withAddress: (Double, Double)) {
        Task(priority: .background) {
            let result = await weatherService.getWeather(latitude: String(withAddress.0), longitude: String(withAddress.1))
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    print("response JSON \n\n\n\(weatherResponse)")
                    // get image
                    self.updateUI?(weatherResponse)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
