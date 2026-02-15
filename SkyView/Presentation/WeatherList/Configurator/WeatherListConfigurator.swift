//
//  WeatherListConfigurator.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

enum WeatherListConfigurator {
    /// Создаёт и настраивает экран списка погоды с внедрёнными зависимостями.
    ///
    /// - Parameter container: Контейнер зависимостей.
    /// - Returns: Настроенный экземпляр `WeatherListView`.
    static func configure(container: DependencyContainer) -> WeatherListView {
        let viewModel = WeatherListViewModel(useCase: container.loadAllWeatherUseCase)
        return WeatherListView(viewModel: viewModel)
    }
}
