//
//  WeatherModel.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//

import Foundation

typealias TimeInterval = Double

struct WeatherModel : Codable {
    let coord: Coordinate?
    let weather: [WeatherConditionItem]?
    let base: String?
    let main: WeatherMain?
    let visibility: Double?
    let wind: Wind?
    let rain: Volume?
    let snow: Volume?
    let dt: TimeInterval?
    let sys: WeatherSystem?
    let timezone: TimeInterval?
    let id: Int?
    let name: String?
    let cod: Int?
}

//coord
struct Coordinate  : Codable {
    let lon: Double?
    let lat: Double?
}

//weather
struct WeatherConditionItem : Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

//main
struct WeatherMain : Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Double?
    let humidity: Double?
    let sea_level: Double?
    let grnd_level: Double?
}

//wind
struct Wind : Codable {
    let speed: Double?
    let deg: Double?
    let gust: Double?
}

//clouds
struct Clouds : Codable {
    let all: Double?
}

struct Volume : Codable {
    let h1: Double?
    let h3: Double?
}

//sys
struct WeatherSystem : Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
}
