//
//  ViewController.swift
//  Weather
//
//  Created by V S Manoj Kumar A on 10/07/24.
//

import UIKit
import CoreLocation // To get or check for current location access we need to import this package

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() // The object we created get hold of our current GPS location of the device.
    // In order to use this firstly, we need to make a permission request in the viewDidLoad method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Shows a popup on the screen to the user for permission
        locationManager.requestLocation()

        weatherManager.delegate = self
        searchTextField.delegate = self // Telling the view to obey with the user interactions with the view.
    }
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // This lines hides the keyboard when the user clicks on the return key from the keyboard
        print(searchTextField.text!)
    }
    
    // What ever we type in the text field by clicking on return from the keyboard the text entered in the text field should be printed.
    // This is a inbuilt function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    // If the user didn't type anything and clicks on return then the keyboard shouldn't just hide instead the placeholder willl give some information on what the user have to do.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    // To clear the text field after the search is finished.
    // This is a inbuilt function
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
