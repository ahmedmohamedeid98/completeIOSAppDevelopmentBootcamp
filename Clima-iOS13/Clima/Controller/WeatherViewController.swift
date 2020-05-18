//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, WeatherManagerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK:- Properities
    var locationManager : CLLocationManager!
    var weatherManager = WeatherManager()
    
    
    //MARK:- Init ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }

    fileprivate func initVC() {
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    
    // note this func call in background
    func didUpdateWeatherData(data: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: data.conditionImageName)
            self.cityLabel.text = data.cityName
            self.temperatureLabel.text = data.temperatureString
        }
    }
    func fialdWithError(error: String) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: "")
            self.cityLabel.text = error
            self.temperatureLabel.text = "0.0"
        }
    }
    
    @IBAction func locationBtnPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
}

//MARK:- TextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.currentWeatherDataByCity(name: city)
        }
        textField.text = ""
    }
}
// Setup LocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("lat: \(lat), lon: \(lon)")
            weatherManager.currentWeatherDataByLocation(lat: lon, lon: lat)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("faild to update location [Error] : \(error.localizedDescription)")
    }
}
