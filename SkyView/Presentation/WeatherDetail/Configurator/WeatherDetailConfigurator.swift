//
//  WeatherDetailConfigurator.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

enum WeatherDetailConfigurator {
    /// Создаёт и настраивает экран детальной погоды по данным города.
    ///
    /// - Parameter cityWeather: Модель погоды по городу (название, данные, идентификатор и т.д.).
    /// - Returns: Настроенный экземпляр `WeatherDetailView` для отображения.
    static func configure(cityWeather: CityWeather) -> WeatherDetailView {
        let viewModel = WeatherDetailViewModel(cityWeather: cityWeather)
        return WeatherDetailView(viewModel: viewModel)
    }
}
