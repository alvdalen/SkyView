//
//  DayForecast.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

struct DayForecast: Identifiable, Hashable, Sendable {
    let id: String
    let date: Date
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let visibility: Int
    let clouds: Int
    let description: String
    let icon: String
}
