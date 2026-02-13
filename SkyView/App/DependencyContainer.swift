//
//  DependencyContainer.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

/// Сборка зависимостей. Создаётся один раз в точке входа и передаётся в экраны.
final class DependencyContainer {

    let weatherRepository: WeatherFetching
    let loadAllWeatherUseCase: LoadAllWeatherUseCase

    init() {
        let dataLoader = NetworkService()
        let parser = WeatherParser()
        weatherRepository = WeatherRepository(
            dataLoader: dataLoader,
            parser: parser
        )
        loadAllWeatherUseCase = LoadAllWeatherUseCaseExecutor(repository: weatherRepository)
    }
}
