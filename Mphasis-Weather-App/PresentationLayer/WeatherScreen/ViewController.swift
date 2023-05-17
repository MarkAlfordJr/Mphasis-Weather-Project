//
//  ViewController.swift
//  Mphasis-Weather-App
//
//  Created by Mark Alford on 5/16/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: Objects
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
    
    //MARK: Initializers and Lifecycles
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
    
    /// used within the AppDelegate's life cycle function. This is a attempt to save the data upon the app terminating.
    func saveData() {
        let lastText = weatherSearchBar.searchTextField.text
        defaults.set(lastText, forKey: "LastTerm")
        location.stopUpdatingLocation()
    }
    
    /// this will call the API again with the loaded cached data.
    func initialLoad() {
        if defaults.bool(forKey: "LastTerm") == true {
            let cachedData = defaults.string(forKey: "LastTerm")
            viewmodel.convertAddresstoCoordinates(by: cachedData ?? "New York")
            viewmodel.updateUI = { [weak self] data in
                // calculating the temperatures
                let temperature = data.main.temp
                let fahrenheit = String(format: "%.0f", (((temperature - 273.15) * 9) / 5) + 32)
                let celsuis = String(format: "%.0f", temperature - 273.15)
                // loading the UI
                DispatchQueue.main.async {
                    self?.configureViews(imgString: data.weather.first?.icon ?? "01n", tempF: "\(fahrenheit) F", tempC: "\(celsuis) C", cityName: data.name, countryName: data.sys.country, description: data.weather.first?.description ?? "No Weather")
                }
            }
        } else {
            print("cached data is NOT present")
        }
    }
    
    //MARK: View Contraints
    // sets the constraints of the views
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
    
    //MARK: View Configruation
    /**
     func to fill the UI with data from the Viewmodel's JSON
     - Parameters:
        - imgString: the icon's name, needed for helping the image download it from a URL.
        - tempF: the converted Fahrenheit value from the JSON temp var
        - tempC: the converted Celsius value from the JSON temp var
        - cityName: JSON city name
        - countryName: JSON country name, just a TWO letter inital
        - description: JSON weather's description
     */
    func configureViews(imgString: String, tempF: String, tempC: String, cityName: String, countryName: String, description: String) {
        weatherImage.downloadImg(from: imgString)
        bigTempFLabel.text = tempF
        smallTempCLabel.text = tempC
        cityLabel.text = cityName
        countryLabel.text = countryName
        descriptionLabel.text = description
    }
}

//MARK: SearchBar functionality
extension ViewController: UISearchBarDelegate {
    /**
      handles the functionality when the user presses enter on their keyboard, after entering text into the search bar.
     - Parameters:
        - searchBar: the search bar UI, from the view initialized above
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            print("Search bar text not collected")
            return
        }
        print(text)
        /// the user's search string is converted into actual coordinates using CoreLocation. then the JSON from the actual API is loaded into the UI.
        viewmodel.convertAddresstoCoordinates(by: text)
        viewmodel.updateUI = { [weak self] data in
            let temperature = data.main.temp
            let fahrenheit = String(format: "%.0f", (((temperature - 273.15) * 9) / 5) + 32)
            let celsuis = String(format: "%.0f", temperature - 273.15)
            self?.configureViews(imgString: data.weather.first?.icon ?? "01n", tempF: "\(fahrenheit) F", tempC: "\(celsuis) C", cityName: data.name, countryName: data.sys.country, description: data.weather.first?.description ?? "No Weather")
        }
       
    }
}

//MARK: Core Location functionality
extension ViewController: CLLocationManagerDelegate {
    /**
      Used for loading the app with the user's coordinates upon launch. The user must request permission first, which is stated in the plist
     - Parameters:
        - manager: the location object to be used
        - locations: an array of all the recorded coordinates from the user's device
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locations = locations.first {
            let lat = locations.coordinate.latitude
            let lon = locations.coordinate.longitude
            let coordinates = (lat, lon)
            print(coordinates)
            viewmodel.getWeather(withAddress: coordinates)
            viewmodel.updateUI = { [weak self] data in
                // calculating the temperatures
                let temperature = data.main.temp
                let fahrenheit = String(format: "%.0f", (((temperature - 273.15) * 9) / 5) + 32)
                let celsuis = String(format: "%.0f", temperature - 273.15)
                // loading the UI
                DispatchQueue.main.async {
                    self?.configureViews(imgString: data.weather.first?.icon ?? "01n", tempF: "\(fahrenheit) F", tempC: "\(celsuis) C", cityName: data.name, countryName: data.sys.country, description: data.weather.first?.description ?? "No Weather")
                }
                
            }
        }
    }
    
    
}
