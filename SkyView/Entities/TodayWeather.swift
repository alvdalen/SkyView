//
//  TodayWeather.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

struct TodayWeather: Hashable, Sendable {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let visibility: Int
    let clouds: Int
    let description: String
    let icon: String
    let updatedAt: Date
}
