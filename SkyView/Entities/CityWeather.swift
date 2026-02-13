//
//  CityWeather.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

struct CityWeather: Identifiable, Hashable, Sendable {
    let city: City
    let current: TodayWeather
    let daily: [DayForecast]

    var id: String { city.id }
}
