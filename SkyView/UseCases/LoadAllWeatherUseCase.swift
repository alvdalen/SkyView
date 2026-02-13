//
//  LoadAllWeatherUseCase.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

/// Загрузка погоды по всем столицам. Результат готов для отображения в списке.
protocol LoadAllWeatherUseCase: Sendable {
    func execute() async -> LoadAllWeatherOutcome
}

final class LoadAllWeatherUseCaseExecutor: LoadAllWeatherUseCase {
    
    private let repository: WeatherFetching
    
    init(repository: WeatherFetching) {
        self.repository = repository
    }
    
    func execute() async -> LoadAllWeatherOutcome {
        let results = await repository.fetchAllWeather()
        
        var items: [CityWeather] = []
        var errors: [String] = []
        
        for result in results {
            switch result {
            case .success(let weather):
                items.append(weather)
            case .failure(let error):
                errors.append(error.localizedDescription)
            }
        }
        
        let errorMessage: String? = items.isEmpty && !errors.isEmpty ? errors.first : nil
        return LoadAllWeatherOutcome(items: items, errorMessage: errorMessage)
    }
}
