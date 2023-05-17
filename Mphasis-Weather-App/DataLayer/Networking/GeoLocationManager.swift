//
//  GeoLocationManager.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import Foundation
import CoreLocation

protocol GeolocationManagerProtocol {
    func forwardGeocoding(address: String)
}

final class GeolocationManager: GeolocationManagerProtocol {
    let locationManager = CLLocationManager()
    
    // completion handler used to update the VC with the convert coordinates
    var updateUI: ((_ coordinates: (Double, Double)) -> Void)?
    
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
                self.updateUI?((coordinate.latitude, coordinate.longitude))
            }
            else
            {
                print("No Matching Location Found")
            }
        })
    }
}
