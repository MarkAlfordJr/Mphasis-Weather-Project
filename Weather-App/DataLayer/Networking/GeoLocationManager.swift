//
//  GeoLocationManager.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation
import CoreLocation

/// used for dependency injection at a later date
protocol GeolocationManagerProtocol {
    func forwardGeocoding(address: String)
}

/// class used for converting the user's location into coordinates, for the API call
final class GeolocationManager: GeolocationManagerProtocol {
    // core location object
    let locationManager = CLLocationManager()
    
    // completion handler used to call the actual API with the convert coordinates
    var updateUI: ((_ coordinates: (Double, Double)) -> Void)?
    
    /**
     func used for converting the user's location strings into Coordinates for the Open Weather API.
     - Parameters   address: String address from the search bar text within the home screen. can be city, address, location, etc.
     */
    func forwardGeocoding(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Failed to retrieve location")
                return
            }
            
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                print("base coordinate object: \(coordinate)\n")
                print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
                // the completion handler on line 21 will be called with the user's coordinates, within the screen's viewModel
                self.updateUI?((coordinate.latitude, coordinate.longitude))
            }
            else
            {
                print("No Matching Location Found")
            }
        })
    }
}
