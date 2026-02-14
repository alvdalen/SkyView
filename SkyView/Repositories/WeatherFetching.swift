//
//  WeatherFetching.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

protocol WeatherFetching: Sendable {
    func fetchWeather(for city: City) async -> Result<CityWeather, Error>
    func fetchAllWeather() async -> [Result<CityWeather, Error>]
}
