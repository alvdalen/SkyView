//
//  WeatherDetailConfigurator.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

enum WeatherDetailConfigurator {
    static func configure(cityWeather: CityWeather) -> WeatherDetailView {
        let viewModel = WeatherDetailViewModel(cityWeather: cityWeather)
        return WeatherDetailView(viewModel: viewModel)
    }
}
