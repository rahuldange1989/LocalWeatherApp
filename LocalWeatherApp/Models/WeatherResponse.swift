//
//  WeatherResponse.swift
//  LocalWeatherApp
//
//  Created by Rahul Dange on 07/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct WeatherResponse: Codable {
    let latitude, longitude: Double?
    let timezone: String?
    let currently: Currently?
    let hourly: Hourly?
    let daily: Daily?
    let flags: Flags?
    let offset: Int?
}

// MARK: - Currently
struct Currently: Codable {
    let time: Int?
    let summary: String?
    let icon: String?
    let precipIntensity, precipProbability: Double?
    let precipType: String?
    let temperature, apparentTemperature, dewPoint, humidity: Double?
    let pressure, windSpeed, windGust: Double?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex, visibility: Int?
    let ozone: Double?
}

// MARK: - Daily
struct Daily: Codable {
    let summary: String?
    let icon: String?
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let time: Int?
    let summary, icon: String?
    let sunriseTime, sunsetTime: Int?
    let moonPhase, precipIntensity, precipIntensityMax: Double?
    let precipIntensityMaxTime: Int?
    let precipProbability: Double?
    let precipType: String?
    let temperatureHigh: Double?
    let temperatureHighTime: Int?
    let temperatureLow: Double?
    let temperatureLowTime: Int?
    let apparentTemperatureHigh: Double?
    let apparentTemperatureHighTime: Int?
    let apparentTemperatureLow: Double?
    let apparentTemperatureLowTime: Int?
    let dewPoint, humidity, pressure, windSpeed: Double?
    let windGust: Double?
    let windGustTime, windBearing: Int?
    let cloudCover: Double?
    let uvIndex, uvIndexTime: Int?
    let visibility, ozone, temperatureMin: Double?
    let temperatureMinTime: Int?
    let temperatureMax: Double?
    let temperatureMaxTime: Int?
    let apparentTemperatureMin: Double?
    let apparentTemperatureMinTime: Int?
    let apparentTemperatureMax: Double?
    let apparentTemperatureMaxTime: Int?
}

// MARK: - Flags
struct Flags: Codable {
    let sources: [String]
    let meteoalarmLicense: String?
    let nearestStation: Double?
    let units: String?

    enum CodingKeys: String, CodingKey {
        case sources
        case meteoalarmLicense = "meteoalarm-license"
        case nearestStation = "nearest-station"
        case units
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let summary: String?
    let icon: String?
    let data: [Currently]
}
