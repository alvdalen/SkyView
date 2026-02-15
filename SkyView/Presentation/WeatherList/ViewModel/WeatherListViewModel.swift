//
//  WeatherListViewModel.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import Combine

@MainActor
final class WeatherListViewModel: ObservableObject {
    // MARK: Private Properties
    @Published private(set) var state: WeatherListState = .idle
    @Published private(set) var refreshingCityId: String? = nil
    private let useCase: LoadAllWeatherUseCase
    
    // MARK: Internal Properties
    var loadedItems: [CityWeather]? {
        if case .loaded(let items) = state { return items }
        return nil
    }
    
    // MARK: Initializers
    init(useCase: LoadAllWeatherUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Internal Methods
    func refresh() async {
        guard !state.isLoading else { return }
        state = .loading

        let outcome = await useCase.execute()
        if outcome.items.isEmpty, let message = outcome.errorMessage {
            state = .failed(message)
        } else {
            state = .loaded(outcome.items)
        }
    }
    
    func refreshCity(_ cityId: String) async {
        guard refreshingCityId == nil else { return }
        refreshingCityId = cityId
        defer { refreshingCityId = nil }

        do {
            let weather = try await useCase.fetchWeather(cityId: cityId)
            guard case .loaded(var items) = state else { return }
            if let index = items.firstIndex(where: { $0.city.id == cityId }) {
                items[index] = weather
                state = .loaded(items)
            }
        } catch {
            
        }
    }
}

// MARK: - State
/// Состояние экрана списка погоды.
enum WeatherListState {
    case idle
    case loading
    case loaded([CityWeather])
    case failed(String)
}

extension WeatherListState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
