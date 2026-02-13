//
//  PreviewWeatherRepository.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

/// Репозиторий для Preview и тестов. Не обращается к сети.
struct PreviewWeatherRepository: WeatherFetching {
    func fetchWeather(for city: City) async throws -> CityWeather {
        CityWeather(
            city: city,
            current: TodayWeather(
                temperature: 0,
                feelsLike: 0,
                humidity: 0,
                pressure: 0,
                windSpeed: 0,
                visibility: 0,
                clouds: 0,
                description: "—",
                icon: "—",
                updatedAt: Date()
            ),
            daily: []
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
                    daily: []
                )
            )
        }
    }
}
