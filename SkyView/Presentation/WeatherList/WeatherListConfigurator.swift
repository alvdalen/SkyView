//
//  WeatherListConfigurator.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

enum WeatherListConfigurator {
    static func configure(container: DependencyContainer) -> ContentView {
        let viewModel = WeatherListViewModel(useCase: container.loadAllWeatherUseCase)
        return ContentView(viewModel: viewModel)
    }
}
