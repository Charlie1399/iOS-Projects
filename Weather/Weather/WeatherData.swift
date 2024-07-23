//
//  WeatherData.swift
//  Weather
//
//  Created by V S Manoj Kumar A on 17/07/24.
//

import Foundation

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
