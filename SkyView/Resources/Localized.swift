//
//  Localized.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

enum Localized {
    // Список погоды
    static var weatherTitle: String { String(localized: "weather_title") }
    static var retryButton: String { String(localized: "retry_button") }
    static var openWeatherMapLink: String { String(localized: "open_weather_map_link") }

    // Детали погоды - секция прогноза
    static var forecastSectionTitle: String { String(localized: "forecast_section_title") }

    // Подписи метрик в сетке
    static var metricWind: String { String(localized: "metric_wind") }
    static var metricFeelsLike: String { String(localized: "metric_feels_like") }
    static var metricHumidity: String { String(localized: "metric_humidity") }
    static var metricPressure: String { String(localized: "metric_pressure") }
    static var metricVisibility: String { String(localized: "metric_visibility") }
    static var metricClouds: String { String(localized: "metric_clouds") }

    // Единицы измерения
    static var unitWindSpeed: String { String(localized: "unit_wind_speed") }
    static var unitPressure: String { String(localized: "unit_pressure") }
    static var visibilityKm10Plus: String { String(localized: "visibility_km_10_plus") }
    static var visibilityKmFormat: String { String(localized: "visibility_km_format") }
    static var visibilityM: String { String(localized: "visibility_m") }
}
