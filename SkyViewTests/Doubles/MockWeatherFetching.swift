//
//  MockWeatherFetching.swift
//  SkyViewTests
//
//  Created by Adam on 16.02.2026.
//

import Foundation
@testable import SkyView

/// Репозиторий для тестов: по умолчанию делегирует в `PreviewWeatherRepository`,
/// при необходимости отдаёт заданные результаты или ошибки.
final class MockWeatherFetching: WeatherFetching, @unchecked Sendable {
    var fetchAllOverride: [Result<CityWeather, Error>]?
    var fetchAllDelayNanoseconds: UInt64 = 0

    var fetchWeatherOverride: Result<CityWeather, Error>?
    var fetchWeatherDelayNanoseconds: UInt64 = 0
    
    private let preview = PreviewWeatherRepository()

    func fetchAllWeather() async -> [Result<CityWeather, Error>] {
        if fetchAllDelayNanoseconds > 0 {
            try? await Task.sleep(nanoseconds: fetchAllDelayNanoseconds)
        }
        if let override = fetchAllOverride {
            return override
        }
        return await preview.fetchAllWeather()
    }

    func fetchWeather(for city: City) async -> Result<CityWeather, Error> {
        if fetchWeatherDelayNanoseconds > 0 {
            try? await Task.sleep(nanoseconds: fetchWeatherDelayNanoseconds)
        }
        if let override = fetchWeatherOverride {
            return override
        }
        return await preview.fetchWeather(for: city)
    }
}
