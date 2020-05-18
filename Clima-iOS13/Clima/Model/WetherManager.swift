//
//  WetherManager.swift
//  Clima
//
//  Created by Ahemd Eid on 5/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//
import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeatherData(data: WeatherModel)
    func fialdWithError(error: String)
}

class WeatherManager {
    static var shared = WeatherManager()
    // Here put your API_KEY
    let weather_url = "https://api.openweathermap.org/data/2.5/weather?appid={API_KEY}&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func currentWeatherDataByCity(name: String) {
        if let url = URL(string: "\(weather_url)&q=\(name)") {
            preformRequestWith(url)
        }
    }
    
    func currentWeatherDataByLocation(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        if let url = URL(string:"\(weather_url)?lat=\(lat)&lon=\(lon)") {
            preformRequestWith(url)
        }
    }
    
    func preformRequestWith(_ url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("no data: \(e.localizedDescription)")
                self.delegate?.fialdWithError(error: e.localizedDescription)
            } else {
                if let safeData = data {
                    if let decodedData = self.decodeData(data: safeData) {
                        self.delegate?.didUpdateWeatherData(data: decodedData)
                    }
                }
            }
        }
        task.resume()
    }
    
    func decodeData(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            print(String(data: data, encoding: .utf8)!)
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            return WeatherModel(conditionId: weatherData.weather[0].id, cityName: weatherData.name, temperature: weatherData.main.temp)
        } catch {
            print("faild decode data: \(error.localizedDescription)")
            delegate?.fialdWithError(error: error.localizedDescription)
            return nil
        }
    }
    
}
