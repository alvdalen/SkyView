//
//  LoadAllWeatherUseCase.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

/// Загрузка погоды по всем столицам. Результат готов для отображения в списке.
protocol LoadAllWeatherUseCase: Sendable {
    func execute() async -> LoadAllWeatherOutcome
    func fetchWeather(cityId: String) async throws -> CityWeather
}
