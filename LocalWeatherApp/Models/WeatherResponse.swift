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
    let offset: Double?
}

// MARK: - Currently
struct Currently: Codable {
    let time: Double?
    let summary: String?
    let icon: String?
    let precipIntensity, precipProbability: Double?
    let precipType: String?
    let temperature, apparentTemperature, dewPoint, humidity: Double?
    let pressure, windSpeed, windGust: Double?
    let windBearing: Double?
    let cloudCover: Double?
    let uvIndex, visibility: Double?
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
    let time: Double?
    let summary, icon: String?
    let sunriseTime, sunsetTime: Double?
    let moonPhase, precipIntensity, precipIntensityMax: Double?
    let precipIntensityMaxTime: Double?
    let precipProbability: Double?
    let precipType: String?
    let temperatureHigh: Double?
    let temperatureHighTime: Double?
    let temperatureLow: Double?
    let temperatureLowTime: Double?
    let apparentTemperatureHigh: Double?
    let apparentTemperatureHighTime: Double?
    let apparentTemperatureLow: Double?
    let apparentTemperatureLowTime: Double?
    let dewPoint, humidity, pressure, windSpeed: Double?
    let windGust: Double?
    let windGustTime, windBearing: Double?
    let cloudCover: Double?
    let uvIndex, uvIndexTime: Double?
    let visibility, ozone, temperatureMin: Double?
    let temperatureMinTime: Double?
    let temperatureMax: Double?
    let temperatureMaxTime: Double?
    let apparentTemperatureMin: Double?
    let apparentTemperatureMinTime: Double?
    let apparentTemperatureMax: Double?
    let apparentTemperatureMaxTime: Double?
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
