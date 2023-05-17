//
//  ViewController.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var viewmodel = WeatherScreenViewModel()
    let defaults = UserDefaults.standard
    var location = CLLocationManager()
    
    // MARK: Views
    let weatherSearchBar: UISearchBar = {
        var search = UISearchBar()
        search.searchBarStyle = UISearchBar.Style.default
        search.placeholder = "Search Location"
        search.isTranslucent = false
        search.sizeToFit()
        return search
    }()
    
    // drink image
    var weatherImage: UIImageView = {
        var image = UIImageView()
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.backgroundColor = UIColor.systemMint
        return image
    }()
    
    let bigTempFLabel: UILabel = {
       var textLabel = UILabel()
        textLabel.text = "00 F"
        textLabel.textAlignment = .left
        textLabel.font = UIFont.boldSystemFont(ofSize: 64)
        return textLabel
    }()
    
    let smallTempCLabel: UILabel = {
       var textLabel = UILabel()
        textLabel.text = "00 C"
        textLabel.textAlignment = .left
        textLabel.font = UIFont.boldSystemFont(ofSize: 32)
        return textLabel
    }()
    
    let cityLabel: UILabel = {
       var textLabel = UILabel()
        textLabel.text = "city"
        textLabel.textAlignment = .left
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return textLabel
    }()
    
    let countryLabel: UILabel = {
       var textLabel = UILabel()
        textLabel.text = "country"
        textLabel.textAlignment = .left
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return textLabel
    }()
    
    let descriptionLabel: UILabel = {
       var textLabel = UILabel()
        textLabel.text = "weather description"
        textLabel.textAlignment = .left
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    //load cached data here
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(weatherSearchBar)
        view.addSubview(weatherImage)
        view.addSubview(bigTempFLabel)
        view.addSubview(smallTempCLabel)
        view.addSubview(cityLabel)
        view.addSubview(countryLabel)
        view.addSubview(descriptionLabel)
        view.backgroundColor = UIColor.systemBackground
        weatherSearchBar.delegate = self
        weatherSearchBar.backgroundImage = UIImage()
        setupConstraint()
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        initialLoad()
    }
    
    func saveData() {
        let lastText = weatherSearchBar.searchTextField.text
        defaults.set(lastText, forKey: "LastTerm")
        location.stopUpdatingLocation()
    }
    
    func initialLoad() {
        if defaults.bool(forKey: "LastTerm") == true {
            print("cached data is present after second launch")
            let cachedData = defaults.string(forKey: "LastTerm")
            print(cachedData as Any)
            viewmodel.convertAddresstoCoordinates(by: cachedData ?? "New York")
            viewmodel.updateUI = { [weak self] data in
                let temperature = data.main.temp
                let fahrenheit = String(format: "%.0f", (((temperature - 273.15) * 9) / 5) + 32)
                let celsuis = String(format: "%.0f", temperature - 273.15)
                self?.configureViews(imgString: data.weather.first?.icon ?? "01n", tempF: "\(fahrenheit) F", tempC: "\(celsuis) C", cityName: data.name, countryName: data.sys.country, description: data.weather.first?.description ?? "No Weather")
            }
        } else {
            print("cached data is NOT present")
        }
    }
    
    func setupConstraint() {
        weatherSearchBar.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        bigTempFLabel.translatesAutoresizingMaskIntoConstraints = false
        smallTempCLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            weatherSearchBar.topAnchor.constraint(equalTo: guide.topAnchor),
            weatherSearchBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            weatherSearchBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            
            weatherImage.widthAnchor.constraint(equalToConstant: 100.0),
            weatherImage.heightAnchor.constraint(equalToConstant: 100.0),
            weatherImage.leadingAnchor.constraint(equalTo: weatherSearchBar.leadingAnchor, constant: 8),
            weatherImage.topAnchor.constraint(equalTo: weatherSearchBar.bottomAnchor, constant: 32.0),
            
            bigTempFLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 16.0),
            bigTempFLabel.leadingAnchor.constraint(equalTo: weatherImage.leadingAnchor),
            
            smallTempCLabel.topAnchor.constraint(equalTo: bigTempFLabel.topAnchor),
            smallTempCLabel.leadingAnchor.constraint(equalTo: bigTempFLabel.trailingAnchor, constant: 16),
            
            cityLabel.topAnchor.constraint(equalTo: bigTempFLabel.bottomAnchor, constant: 16.0),
            cityLabel.leadingAnchor.constraint(equalTo: weatherImage.leadingAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8.0),
            countryLabel.leadingAnchor.constraint(equalTo: weatherImage.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 8.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: weatherImage.leadingAnchor),
        ])
    }
    
    func configureViews(imgString: String, tempF: String, tempC: String, cityName: String, countryName: String, description: String) {
        weatherImage.downloadImg(from: imgString)
        bigTempFLabel.text = tempF
        smallTempCLabel.text = tempC
        cityLabel.text = cityName
        countryLabel.text = countryName
        descriptionLabel.text = description
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            print("Search bar text not collected")
            return
        }
        print(text)
        viewmodel.convertAddresstoCoordinates(by: text)
        viewmodel.updateUI = { [weak self] data in
            let temperature = data.main.temp
            let fahrenheit = String(format: "%.0f", (((temperature - 273.15) * 9) / 5) + 32)
            let celsuis = String(format: "%.0f", temperature - 273.15)
            self?.configureViews(imgString: data.weather.first?.icon ?? "01n", tempF: "\(fahrenheit) F", tempC: "\(celsuis) C", cityName: data.name, countryName: data.sys.country, description: data.weather.first?.description ?? "No Weather")
        }
       
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locations = locations.first {
            let lat = locations.coordinate.latitude
            let lon = locations.coordinate.longitude
            let coordinates = (lat, lon)
            print(coordinates)
            viewmodel.getWeather(withAddress: coordinates)
            viewmodel.updateUI = { [weak self] data in
                let temperature = data.main.temp
                let fahrenheit = String(format: "%.0f", (((temperature - 273.15) * 9) / 5) + 32)
                let celsuis = String(format: "%.0f", temperature - 273.15)
                self?.configureViews(imgString: data.weather.first?.icon ?? "01n", tempF: "\(fahrenheit) F", tempC: "\(celsuis) C", cityName: data.name, countryName: data.sys.country, description: data.weather.first?.description ?? "No Weather")
            }
        }
    }
    
    
}
