//
//  WeatherModel.swift
//  WeatherSearching
//
//  Created by Andres Chan on 5/6/2021.
//

import Foundation

typealias TimeInterval = Double

struct WeatherModel : Codable, Identifiable, Hashable {
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var coord: Coordinate?
    var weather: [WeatherConditionItem]?
    var base: String?
    var main: WeatherMain?
    var visibility: Double?
    var wind: Wind?
    var rain: Volume?
    var snow: Volume?
    var dt: TimeInterval?
    var sys: WeatherSystem?
    var timezone: TimeInterval?
    var id: Int?
    var name: String?
    var cod: Int?
}

//coord
struct Coordinate  : Codable {
    var lon: Double?
    var lat: Double?
}

//weather
struct WeatherConditionItem : Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

//main
struct WeatherMain : Codable {
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Double?
    var humidity: Double?
    var sea_level: Double?
    var grnd_level: Double?
}

//wind
struct Wind : Codable {
    var speed: Double?
    var deg: Double?
    var gust: Double?
}

//clouds
struct Clouds : Codable {
    var all: Double?
}

struct Volume : Codable {
    var h1: Double?
    var h3: Double?
}

//sys
struct WeatherSystem : Codable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: TimeInterval?
    var sunset: TimeInterval?
}
