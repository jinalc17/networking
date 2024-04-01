//
//  Weather.swift
//  Networking
//
//  Created by user239775 on 4/1/24.
//

import Foundation

struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherInfo]
    let base: String
    let main: MainWeatherInfo
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds?
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeatherInfo: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

