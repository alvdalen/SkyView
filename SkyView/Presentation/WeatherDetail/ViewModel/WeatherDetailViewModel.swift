//
//  WeatherDetailViewModel.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import Combine

@MainActor
final class WeatherDetailViewModel: ObservableObject {
    let cityWeather: CityWeather

    init(cityWeather: CityWeather) {
        self.cityWeather = cityWeather
    }

    /// Текущая погода (для шапки экрана).
    var current: TodayWeather {
        cityWeather.current
    }

    /// Прогноз по дням (до 8 дней из API).
    var dailyForecast: [DayForecast] {
        cityWeather.daily
    }

    /// Название города для заголовка (только город, без страны).
    var cityDisplayName: String {
        cityWeather.city.name
    }

    func dayTitle(for day: DayForecast) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: day.date)
    }
}
