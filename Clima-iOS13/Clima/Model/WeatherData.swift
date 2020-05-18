//
//  WeatherData.swift
//  Clima
//
//  Created by Ahmed Eid on 5/18/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

