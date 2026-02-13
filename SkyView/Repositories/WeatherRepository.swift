//
//  WeatherRepository.swift
//  SkyView
//
//  Created by Adam on 13.02.2026.
//

import Foundation

final class WeatherRepository: WeatherFetching {

    private let dataLoader: DataLoading
    private let parser: WeatherParsing

    init(dataLoader: DataLoading, parser: WeatherParsing) {
        self.dataLoader = dataLoader
        self.parser = parser
    }

    func fetchWeather(for city: City) async throws -> CityWeather {
        let url = try makeURL(city: city)
        let data = try await dataLoader.load(from: url)
        let (single, list): (TodayWeather, [DayForecast]) = try parser.parse(data: data)
        return CityWeather(city: city, current: single, daily: list)
    }

    func fetchAllWeather() async -> [Result<CityWeather, Error>] {
        await withTaskGroup(of: (String, Result<CityWeather, Error>).self) { group in
            for city in CapitalsProvider.list {
                group.addTask {
                    do {
                        let weather = try await self.fetchWeather(for: city)
                        return (city.id, .success(weather))
                    } catch {
                        return (city.id, .failure(error))
                    }
                }
            }

            var results: [(String, Result<CityWeather, Error>)] = []
            for await result in group {
                results.append(result)
            }

            return CapitalsProvider.list.compactMap { city in
                results.first { $0.0 == city.id }?.1
            }
        }
    }

    private func makeURL(city: City) throws -> URL {
        guard var components = URLComponents(string: ApiConfig.baseURL + "/onecall") else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(city.lat)"),
            URLQueryItem(name: "lon", value: "\(city.lon)"),
            URLQueryItem(name: "appid", value: ApiConfig.apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "exclude", value: "minutely,hourly,alerts"),
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
}
