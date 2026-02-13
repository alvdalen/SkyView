//
//  LoadAllWeatherOutcome.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

/// Результат загрузки погоды по всем столицам для экрана списка.
struct LoadAllWeatherOutcome {
    let items: [CityWeather]
    let errorMessage: String?
}
