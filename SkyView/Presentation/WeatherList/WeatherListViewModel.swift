//
//  WeatherListViewModel.swift
//  SkyView
//
//  Created by Adam on 14.02.2026.
//

import Combine

@MainActor
final class WeatherListViewModel: ObservableObject {
    
    @Published private(set) var state: WeatherListState = .idle
    
    private let useCase: LoadAllWeatherUseCase
    
    init(useCase: LoadAllWeatherUseCase) {
        self.useCase = useCase
    }
    
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
