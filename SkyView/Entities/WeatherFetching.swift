//
//  WeatherFetching.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

protocol WeatherFetching: Sendable {
    func fetchWeather(for city: City) async throws -> CityWeather
    func fetchAllWeather() async -> [Result<CityWeather, Error>]
}
