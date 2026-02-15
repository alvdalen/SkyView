//
//  PreviewWeatherRepository.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import Foundation

/// Репозиторий для Preview и тестов. Не обращается к сети.
struct PreviewWeatherRepository: WeatherFetching {
    func fetchWeather(for city: City) async -> Result<CityWeather, Error> {
        .success(
            CityWeather(
                city: city,
                current: TodayWeather(
                    temperature: 12,
                    feelsLike: 10,
                    humidity: 65,
                    pressure: 1015,
                    windSpeed: 4,
                    visibility: 10_000,
                    clouds: 40,
                    description: "Облачно",
                    icon: "03d",
                    updatedAt: Date()
                ),
                daily: Self.makePreviewDaily()
            )
        )
    }

    func fetchAllWeather() async -> [Result<CityWeather, Error>] {
        CapitalsProvider.list.map { city in
            .success(
                CityWeather(
                    city: city,
                    current: TodayWeather(
                        temperature: 20,
                        feelsLike: 18,
                        humidity: 50,
                        pressure: 1013,
                        windSpeed: 5,
                        visibility: 10_000,
                        clouds: 30,
                        description: "Ясно",
                        icon: "01d",
                        updatedAt: Date()
                    ),
                    daily: Self.makePreviewDaily()
                )
            )
        }
    }

    private static func makePreviewDaily() -> [DayForecast] {
        let day: TimeInterval = 86400
        return (0..<8).map { i in
            DayForecast(
                id: "preview_\(i)",
                date: Date(timeIntervalSinceNow: day * Double(i)),
                tempMin: 8,
                tempMax: 18,
                pressure: 1013,
                humidity: 55,
                visibility: 10_000,
                clouds: 30,
                description: "Ясно",
                icon: "01d"
            )
        }
    }
}
