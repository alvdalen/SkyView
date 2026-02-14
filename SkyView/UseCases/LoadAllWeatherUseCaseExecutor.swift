//
//  LoadAllWeatherUseCaseExecutor.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

final class LoadAllWeatherUseCaseExecutor {
    private let repository: WeatherFetching
    
    init(repository: WeatherFetching) {
        self.repository = repository
    }
}

// MARK: - LoadAllWeatherUseCase
extension LoadAllWeatherUseCaseExecutor: LoadAllWeatherUseCase {
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
    
    func fetchWeather(cityId: String) async throws -> CityWeather {
        guard let city = CapitalsProvider.list.first(where: { $0.id == cityId }) else {
            throw NSError(
                domain: "UseCase",
                code: -1, userInfo: [NSLocalizedDescriptionKey: "City not found"]
            )
        }
        let result = await repository.fetchWeather(for: city)
        switch result {
        case .success(let weather):
            return weather
        case .failure(let error):
            throw error
        }
    }
}
